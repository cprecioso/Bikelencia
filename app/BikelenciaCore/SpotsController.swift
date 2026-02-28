import Foundation
@_exported import ValenciaKit

extension URLSession {
  static var automaticDownload: URLSession {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .useProtocolCachePolicy
    configuration.waitsForConnectivity = true

    return URLSession(configuration: configuration)
  }

  static var userInitiatedDownload: URLSession {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    configuration.waitsForConnectivity = false

    return URLSession(configuration: configuration)
  }
}

extension TimeInterval {
  fileprivate static let oneMonth: TimeInterval = 30 * 24 * 60 * 60  // 30 days
}

@Observable
public final class SpotsController {
  public init() {}

  private(set) public var isLoading = false

  private(set) public var bikeParkings = StoredJSONObservable(
    BikeParkings.self,
    at: FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: BikelenciaConfig.appGroupIdentifier
    )!.appending(path: "cached-bike-parkings.json", directoryHint: .notDirectory)
  )

  private let updater = SpotUpdater()
  public func updateData(userInitiated: Bool = false) async throws {
    isLoading = true
    defer { isLoading = false }
    let newData = try await updater.update(userInitiated: userInitiated)
    bikeParkings.value = newData
    UserDefaults(suiteName: BikelenciaConfig.appGroupIdentifier)?
      .set(newData.updatedAt.timeIntervalSince1970, forKey: "lastKnownUpdatedAt")
  }

  public var needsUpdate: Bool {
    guard bikeParkings.ready else { return false }

    if let bikeParkings = bikeParkings.value,
      !bikeParkings.spots.isEmpty,
      let fetchedAt = bikeParkings.fetchedAt,
      Date.now.timeIntervalSince(fetchedAt) <= .oneMonth
    {
      return false
    }

    return true
  }
}

actor SpotUpdater {
  func update(userInitiated: Bool) async throws -> BikeParkings {
    let bikeParkings = try await BikeParkings.fetch(
      urlSession: userInitiated ? .userInitiatedDownload : .automaticDownload
    )

    return bikeParkings
  }
}
