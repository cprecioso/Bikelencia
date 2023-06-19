import Foundation

private let JSON_DATA_URL = URL(string: "https://valenciakit.vercel.app/api/bike-parkings")!

extension BikeParkings {
  static public func makeRequest() -> URLRequest {
    URLRequest(url: JSON_DATA_URL)
  }

  static public func fetch(urlSession: URLSession = URLSession(configuration: .ephemeral))
    async throws -> BikeParkings
  {
    let (rawData, _) = try await urlSession.data(for: makeRequest())

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .jsDate

    var data = try decoder.decode(BikeParkings.self, from: rawData)
    data.fetchedAt = Date.now
    return data
  }
}
