import Foundation
import MediaPipeTasksGenAI
import MediaPipeTasksGenAIC

/// Represents the LLM that will be used for inference. It manages a MediaPipe `LlmInference` under the hood.
struct OnDeviceModel {
  /// MediaPipe LlmInference.
  private(set) var inference: LlmInference

  let maxTokens = 1024
  let decdodeTokenOffset = 256

  let modelCategory: Model

  init(model: Model) throws {
    modelCategory = model
    
    var options = LlmInference.Options(modelPath: try model.modelPath)
    options.maxTokens = maxTokens
    inference = try LlmInference(options: options)
  }
}


