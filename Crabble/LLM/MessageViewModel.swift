import Foundation

@MainActor
class MessageViewModel: ObservableObject, Identifiable {
  @Published var chatMessage: ChatMessage

  init(chatMessage: ChatMessage) {
    self.chatMessage = chatMessage
  }

  func update(participant: ChatMessage.Participant) {
    /// Can only update participant of system messages
    guard chatMessage.participant != .user else {
      return
    }

    /// Can only update participant of system message to another system message type
    guard participant != .user else {
      return
    }

    chatMessage.participant = participant
  }

  func update(text: String, participant: ChatMessage.Participant) {
    update(text: text)
    update(participant: participant)
  }

  func update(text: String) {
    switch chatMessage.participant {
    case .user:
      chatMessage.text = text
    default:
      /// Trim any leading characters in whole message.
      chatMessage.text = String(
        (chatMessage.text + text).drop(while: { $0.isWhitespace || $0.isNewline }))
    }
  }
}

/// Represents a single message in the chat.
struct ChatMessage: Identifiable, Equatable {
  /// Unique identifier for the message.
  let id = UUID().uuidString

  /// Text contained in the message.
  var text: String {
    /// didSet gets called whenever the property gets set except for during initialization. Implementation assumes that anyone using
    /// chat message will only set to its `text` after it starts receiving model responses.
    didSet {
      isLoading = false
    }
  }

  /// Indicates if user or system (LLM) has sent the message.
  var participant: Participant
  
  private(set) var isLoading: Bool
  
  var title: String {
    return isLoading && participant == .system(.response) ? "Generating...." : participant.title
  }

  init(text: String = "", participant: Participant, isLoading: Bool=false) {
    self.text = text
    self.participant = participant
    self.isLoading = isLoading
  }
  
  /// Represents the type of message.
  enum Participant: Equatable {

    enum System: Equatable {
      case response
      case error
    }

    case system(_ value: System)
    case user

    var defaultMessage: String {
      switch self {
      case .system(.error):
        return "Some error occured."
      default:
        return ""
      }
    }

    var title: String {
      switch self {
      case .system(.response), .system(.error):
        return "Model"
      case .user:
        return "User"
      }
    }
  }
}

