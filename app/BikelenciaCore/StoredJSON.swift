import Foundation

public actor StoredJSON<Value: Codable> {
  let fileURL: URL

  public init(_: Value.Type, at fileURL: URL) {
    self.fileURL = fileURL
  }

  private var operationInProgress: Bool = false

  public func load() throws -> Value {
    operationInProgress = true
    defer { operationInProgress = false }

    let data = try Data(contentsOf: fileURL)
    return try JSONDecoder().decode(Value.self, from: data)
  }

  public func remove() throws {
    try FileManager.default.removeItem(at: fileURL)
  }

  public func save(_ value: Value) throws {
    operationInProgress = true
    defer { operationInProgress = false }

    let data = try JSONEncoder().encode(value)
    try data.write(to: fileURL, options: [.atomic])
  }
}

@MainActor
@Observable
public final class StoredJSONObservable<Value: Codable & Sendable> {
  let storedJSON: StoredJSON<Value>

  public init(_ type: Value.Type, at fileURL: URL) {
    storedJSON = StoredJSON<Value>(type, at: fileURL)

    Task {
      defer { ready = true }
      value = try? await storedJSON.load()
    }
  }

  private(set) public var ready = false
  public var value: Value? = nil {
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
