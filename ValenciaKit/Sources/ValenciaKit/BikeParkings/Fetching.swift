import Foundation

let JSON_DATA_URL = URL(string: "https://valenciakit.vercel.app/api/bike-parkings")!

public class BikeParkingFetcher {
  static public func fetch(urlSession: URLSession = URLSession.shared) async throws -> BikeParkings
  {
    let session = URLSession(configuration: .ephemeral)
    let (rawData, _) = try await session.data(from: JSON_DATA_URL)
    let data = try JSONDecoder().decode(BikeParkings.self, from: rawData)
    return data
  }
}
