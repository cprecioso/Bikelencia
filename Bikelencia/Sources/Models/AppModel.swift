import Boutique
import Combine
import Foundation
import ValenciaKit

let cacheEngine = SQLiteStorageEngine(
  directory: .caches(appendingPath: "BikeParkings"))!

final class AppModel: ObservableObject {
  @MainActor @Published private(set) internal var isLoading = false

  @AsyncStoredValue(storage: cacheEngine) var bikeParkings: BikeParkings? = nil

  nonisolated static let automaticURLSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .useProtocolCachePolicy
    configuration.waitsForConnectivity = true

    return URLSession(configuration: configuration)
  }()

  nonisolated static let userInitiatedURLSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    configuration.waitsForConnectivity = false

    return URLSession(configuration: configuration)
  }()

  func updateData(userInitiated: Bool) async throws {
    isLoading = true
    defer { isLoading = false }

    // TODO Skip non-user initiated updates if the data is in the cache and low data mode is on

    let urlSession =
      userInitiated ? Self.userInitiatedURLSession : Self.automaticURLSession

    let parkings = try await BikeParkings.fetch(urlSession: urlSession)
    try await self.$bikeParkings.set(parkings)
  }
}
