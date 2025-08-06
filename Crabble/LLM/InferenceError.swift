import Foundation

/// Represents any error thrown by this application.
enum InferenceError: LocalizedError {
  /// Wraps an error thrown by MediaPipe.
  case mediaPipeTasksError(error: Error)
  case modelFileNotFound(modelName: String)
  case onDeviceModelNotInitialized
  case tokensExceeded

  public var errorDescription: String? {
    switch self {
    case .mediaPipeTasksError:
      return "Internal error"
    case .modelFileNotFound:
      return "Model not found"
    case .onDeviceModelNotInitialized:
      return "Model unitialized"
    case .tokensExceeded:
      return "Token limit exceeded"
    }
  }

  public var failureReason: String? {
    switch self {
    case .mediaPipeTasksError(let error):
      return error.localizedDescription
    case .modelFileNotFound(let modelName):
      return "Model with name \(modelName) not found on the disk."
    case .onDeviceModelNotInitialized:
      return "A valid on device model has not been initalized."
    case .tokensExceeded:
      return
        "You have exhausted your token limit for the current session. Please refresh the session."
    }
  }
}

