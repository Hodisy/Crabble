import Foundation

struct ModelMetadata {
  let pathName: String
  let pathExtension: String
  let licenseAcknowledgedKey: String
  let displayName: String
  let downloadUrlString: String
  let licenseUrlString: String?
  let temperature: Float
  let topK: Int
  let topP: Float

  init(
    pathName: String, pathExtension: String, licenseAcknowledgedKey: String = "",
    displayName: String, downloadUrlString: String, licenseUrlString: String? = nil,
    temperature: Float, topK: Int, topP: Float
  ) {
    self.pathName = pathName
    self.pathExtension = pathExtension
    self.licenseAcknowledgedKey = licenseAcknowledgedKey
    self.displayName = displayName
    self.downloadUrlString = downloadUrlString
    self.licenseUrlString = licenseUrlString
    self.temperature = temperature
    self.topK = topK
    self.topP = topP
  }
}

/// Holds the metadata of the models that can be used.
enum Model: CaseIterable {
  case gemma3n

  private var metadata: ModelMetadata {
    switch self {
    case .gemma3n:
      return ModelMetadata(
        pathName: "gemma-3n-E2B-it-int4",
        pathExtension: "task",
        licenseAcknowledgedKey: "gemma-license",
        displayName: "Gemma 3n E2B",
        downloadUrlString:
        "https://huggingface.co/litert-community/Gemma2-2B-IT/resolve/main/Gemma2-2B-IT_multi-prefill-seq_q8_ekv1280.task",
        licenseUrlString: "https://huggingface.co/litert-community/Gemma2-2B-IT",
        temperature: 0.6,
        topK: 50,
        topP: 0.9
      )
    }
  }

  var licenseAcnowledgedKey: String { metadata.licenseAcknowledgedKey }
  var name: String { metadata.displayName }
  var authRequired: Bool { true }
  var temperature: Float { metadata.temperature }
  var topK: Int { metadata.topK }
  var topP: Float { metadata.topP }

  /// Public property to get the model filename
  var modelFileName: String {
    "\(metadata.pathName).\(metadata.pathExtension)"
  }

  private var path: (name: String, extension: String) {
    (metadata.pathName, metadata.pathExtension)
  }

  var downloadUrl: URL {
    URL(string: metadata.downloadUrlString)!
  }

  var licenseUrl: URL? {
    guard let urlString = metadata.licenseUrlString else { return nil }
    return URL(string: urlString)
  }

  var modelPath: String {
    get throws {
      let docsURL = try downloadDestination
      if FileManager.default.fileExists(atPath: docsURL.path) {
        return docsURL.relativePath
      }
      guard
        let path = Bundle.main.path(
          forResource: path.name, ofType: path.extension
        )
      else {
        throw InferenceError.modelFileNotFound(modelName: "\(path.name).\(path.extension)")
      }

      return path
    }
  }

  var downloadDestination: URL {
    get throws {
      let path = try FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      ).appendingPathComponent("\(path.name).\(path.extension)")

      return path
    }
  }
}
