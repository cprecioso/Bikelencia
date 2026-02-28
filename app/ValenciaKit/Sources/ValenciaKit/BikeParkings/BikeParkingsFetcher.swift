import Foundation

extension BikeParkings {
  static public func makeRequest() -> URLRequest {
    URLRequest(url: BikelenciaAPI.bikeParkingsURL)
  }

  static public func fetch(
    urlSession: URLSession = URLSession(configuration: .ephemeral)
  ) async throws -> BikeParkings {
    let (rawData, _) = try await urlSession.data(for: makeRequest())
    var bikeParkings = try JSONDecoder().decode(BikeParkings.self, from: rawData)
    bikeParkings.fetchedAt = .now
    return bikeParkings
  }
}
