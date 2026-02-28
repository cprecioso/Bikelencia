import Foundation
import HelperCoders
import MetaCodable

struct LenientISO8601DateCoder: HelperCoder {
  private nonisolated(unsafe) static let withFractional: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return f
  }()
  private nonisolated(unsafe) static let withoutFractional = ISO8601DateFormatter()

  func decode(from decoder: Decoder) throws -> Date {
    let string = try String(from: decoder)
    guard
      let date = Self.withFractional.date(from: string)
        ?? Self.withoutFractional.date(from: string)
    else {
      throw DecodingError.dataCorrupted(
        .init(
          codingPath: decoder.codingPath,
          debugDescription: "Invalid ISO 8601 date: \(string)"
        ))
    }
    return date
  }

  func encode(_ value: Date, to encoder: Encoder) throws {
    try Self.withFractional.string(from: value).encode(to: encoder)
  }
}
