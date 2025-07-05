import Foundation
import ValenciaKit

extension URLSession {
  fileprivate static var automaticDownload: URLSession {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .useProtocolCachePolicy
    configuration.waitsForConnectivity = true

    return URLSession(configuration: configuration)
  }

  fileprivate static var userInitiatedDownload: URLSession {
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
final class SpotsController {
  private(set) var isLoading = false

  var bikeParkings = StoredJSONObservable(
    BikeParkings.self,
    at: URL.cachesDirectory.appending(
      path: "cached-bike-parkings.json",
      directoryHint: .notDirectory
    )
  )

  private let updater = SpotUpdater()
  func updateData(userInitiated: Bool = false) async throws {
    isLoading = true
    defer { isLoading = false }
    bikeParkings.value = try await updater.update(
      userInitiated: userInitiated
    )
  }

  var needsUpdate: Bool {
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
