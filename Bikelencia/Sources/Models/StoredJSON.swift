import Foundation

actor StoredJSON<Value: Codable> {
  let fileURL: URL

  init(_: Value.Type, at fileURL: URL) {
    self.fileURL = fileURL
  }

  private var operationInProgress: Bool = false

  func load() throws -> Value {
    operationInProgress = true
    defer { operationInProgress = false }

    let data = try Data(contentsOf: fileURL)
    return try JSONDecoder().decode(Value.self, from: data)
  }

  func remove() throws {
    try FileManager.default.removeItem(at: fileURL)
  }

  func save(_ value: Value) throws {
    operationInProgress = true
    defer { operationInProgress = false }

    let data = try JSONEncoder().encode(value)
    try data.write(to: fileURL, options: [.atomic])
  }
}

@Observable
final class StoredJSONObservable<Value: Codable> {
  let storedJSON: StoredJSON<Value>

  init(_ type: Value.Type, at fileURL: URL) {
    storedJSON = StoredJSON<Value>(type, at: fileURL)

    Task {
      defer { ready = true }
      value = try? await storedJSON.load()
    }
  }

  var ready = false
  var value: Value? = nil {
    didSet {
      Task {
        if let value = value {
          try? await storedJSON.save(value)
        } else {
          try? await storedJSON.remove()
        }
      }
    }
  }
}
