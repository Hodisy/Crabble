import Foundation

@MainActor
class ConversationViewModel: ObservableObject {
  /// This array holds both the view models responsible for presentation of both user and system messages
  @Published var messageViewModels = [MessageViewModel]()

  /// .error state is set only when there are errors in loading the model and creating a new chat session.
  /// Response generation errors are relayed as messages from the model.
  enum State: Equatable {
    case idle
    case loadingModel
    case promptSubmitted
    case streamingResponse
    case criticalError(error: InferenceError)
    case nonCriticalError(error: InferenceError)
    case done

    /// Extracts the inference error if the current state is one of the error states.
    var inferenceError: InferenceError? {
      switch self {
      case let .criticalError(error), let .nonCriticalError(error):
        return error
      default:
        return nil
      }
    }

    static func == (lhs: State, rhs: State) -> Bool {
      switch (lhs, rhs) {
      case (.loadingModel, .loadingModel),
        (.promptSubmitted, .promptSubmitted),
        (.streamingResponse, .streamingResponse),
        (.idle, .idle),
        (.done, .done):
        return true
      /// Error equality checks are not required for updates to the UI at the moment. If required more fine grained equality
      /// logic can be implemented here.
      case (.criticalError, .criticalError), (.nonCriticalError, .nonCriticalError):
        return false
      default:
        return false
      }
    }

  }

  /// Based on this property updates are made to the UI State including enabling and disabling of messaging, other buttons etc.
  @Published var currentState: State = .idle

  /// Based on `modelPath` returned by `modelCategory` dictates if download is required.
  @Published var downloadRequired: Bool = true

  /// An approximate estimate of the remaining token count in the context window.
  @Published var remainingSizeInTokens: Int = -1

  /// Model to initialize.
  var modelCategory: Model

  /// Model used for inference. Wraps around a MediaPipe `LlmInference`.
  private var model: OnDeviceModel?

  /// Current conversation with the LLM that preserves history. Wraps around a MediaPipe `LlmInference.Session`.
  private var chat: Chat?

  init(modelCategory: Model) {
    self.modelCategory = modelCategory
    downloadRequired = (try? modelCategory.modelPath) == nil
  }

  func loadModel() {
    guard currentState == .idle, downloadRequired == false else {
      return
    }

    currentState = .loadingModel
    Task {
      load(modelCategory: modelCategory)
    }
  }

  func clearModel() {
    chat = nil
    model = nil
    currentState = .loadingModel
  }

  func handleModelDownloadedCompleted() {
    downloadRequired = false
    currentState = .idle
    loadModel()
  }

  private func load(modelCategory: Model) {
    do {
      /// Gets updated to done or error in `startNewChat()` if there is an error in chat initialization.
      currentState = .loadingModel
      self.model = try OnDeviceModel(model: modelCategory)

      startNewChat()
    } catch let error as InferenceError {
      currentState = .criticalError(error: error)
    } catch {
      currentState = .criticalError(error: InferenceError.mediaPipeTasksError(error: error))
    }
  }

  /// Queries the LLM session with the given text prompt asynchronously. If the prompt completes
  /// successfully, it updates the published `messages` with the new partial response
  /// continuously until the response generation completes. In case of an error, sets the
  /// published `error.
  /// - Parameters:
  ///   - text: Prompt to be sent to the model.
  func sendMessage(_ text: String) {
    Task {
      await internalSendMessage(text)
    }
  }

  /// Clears the current conversation and stats a new chat.
  func startNewChat() {
    /// Setting critical error so that if user tries to click on new chat when no model is initialized the alert is displayed again.
    guard let model else {
      currentState = .criticalError(error: InferenceError.onDeviceModelNotInitialized)
      return
    }

    currentState = .loadingModel

    do {
      chat = try Chat(model: model)
      messageViewModels.removeAll()
      currentState = .done
      remainingSizeInTokens = -1
    } catch {
      currentState = .nonCriticalError(error: InferenceError.mediaPipeTasksError(error: error))
    }
  }

  /// Resets state after error alert is displayed. If it is a critical error (model loading error), then the UI remains disabled and hence the
  /// state shouldn't be reset.
  /// If  the error is a create chat error and there is an ongoing chat session, the state can be set to done since the user can be allowed
  /// to continue chatting with the current session.
  /// If the there is no chat session active, then the UI should remain disabled since it indicates an active session could not be created.
  /// Third scenario would never happen because of the UI guards. Leaving the condition here for correctness.
  func resetStateAfterErrorIntimation() {
    guard case .nonCriticalError = currentState, chat != nil else {
      return
    }

    currentState = .done
  }

  func shouldDisableClicks() -> Bool {
    return shouldDisableClicksForStartNewChat() || remainingSizeInTokens == 0
  }

  func shouldDisableClicksForStartNewChat() -> Bool {
    if case .done = currentState {
      return false
    }
    return true
  }

  func recomputeSizeInTokens(prompt: String) {
    let history = messageViewModels.map { $0.chatMessage.text }.joined(separator: "")
    remainingSizeInTokens =
      chat?.estimateTokensRemaining(
        prompt: prompt, history: history, historyCount: messageViewModels.count)
      ?? remainingSizeInTokens
  }

  /// Sends the message to the currently active instance of `Chat` which in turn queries the underlying MediaPipe
  /// LlmInference.Session to asynchronously stream the response to the prompt. The method adds the new Message VM  with the
  /// message from  the user to the published `messageViewModels` and continuously updates the streamed response.
  private func internalSendMessage(_ text: String) async {
    guard let chat else {
      currentState = .criticalError(error: InferenceError.onDeviceModelNotInitialized)
      return
    }

    currentState = .promptSubmitted
    defer {
      currentState = remainingSizeInTokens == 0 ? .nonCriticalError(error: .tokensExceeded) : .done
    }

    ///Add the user's message to the chat .
    let userViewModel = MessageViewModel(chatMessage: ChatMessage(text: text, participant: .user))
    messageViewModels.append(userViewModel)

    /// Add a generating message to show a progress bar in the message until first token is generated.
    let systemViewModel = MessageViewModel(
      chatMessage: ChatMessage(
        participant: .system(.response),
        isLoading: true))
    messageViewModels.append(systemViewModel)

    do {
      let responseStream = try await chat.sendMessage(text)

      await updateSystemViewModel(systemViewModel, responseStream: responseStream)
      /// Once the inference is done, recompute the remaining size in tokens. Here prompt is empty as the user prompt is already
      /// added to messages along with the response.
      recomputeSizeInTokens(prompt: "")
    } catch {
      handleStreamError(error, for: systemViewModel)
      /// systemViewModel is closed in a defer before exiting this scope. Any errors are handled during close.
    }
  }

  private func updateSystemViewModel(
    _ messageVM: MessageViewModel, responseStream: AsyncThrowingStream<String, any Error>
  ) async {

    defer {
      currentState = .done
    }

    currentState = .streamingResponse
    var currentMessageVM = messageVM

    do {
      for try await partialResult in responseStream {
        currentMessageVM = appendPartialResult(
          partialResult, to: currentMessageVM)
        decrementRemainingSizeInTokens()
      }
    } catch {

      /// The message is partially generated when an error occurred. Add a new message indicating the error rather than updating
      /// the existing message with an error.
      /// If there is a previous message, it's state is updated as done when the messageVM is closed in the calling function.
      handleStreamError(error, for: messageVM)
    }
  }

  private func appendPartialResult(
    _ partialResult: String, to messageVM: MessageViewModel
  ) -> MessageViewModel {
    /// Keep updating the previous message with the partial result.
    messageVM.update(text: partialResult)
    return messageVM
  }

  private func trimmedOfMarkers(text: String) -> String {
    return text
  }
  
  private func decrementRemainingSizeInTokens() {
    remainingSizeInTokens = max(0, remainingSizeInTokens - 1)
  }

  private func handleStreamError(_ error: Error, for messageVM: MessageViewModel) {
    let participant = messageVM.chatMessage.participant
    switch participant {
    case .system(.error):
      self.messageViewModels.append(
        MessageViewModel(chatMessage: ChatMessage(participant: .system(.error)))
      )
    case .system(.response):
      if messageVM.chatMessage.text.count > 0 {
        self.messageViewModels.append(
          MessageViewModel(chatMessage: ChatMessage(participant: .system(.error)))
        )
      } else {
        messageVM.update(text: error.localizedDescription, participant: .system(.error))
      }
    case .user:
      break
    }
  }
}



