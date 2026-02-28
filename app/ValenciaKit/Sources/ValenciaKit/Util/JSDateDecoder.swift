import Foundation

struct JSDateDecoder {
  enum Error: Swift.Error {
    case cantParseDate
  }

  var formatter: ISO8601DateFormatter {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }

  func customDateDecoder(_ decoder: Decoder) throws -> Date {
    let dateStr = try decoder.singleValueContainer().decode(String.self)
    guard let date = formatter.date(from: dateStr) else {
      throw Error.cantParseDate
    }
    return date
  }
}

extension JSONDecoder.DateDecodingStrategy {
  static var jsDate: Self {
    .custom(JSDateDecoder().customDateDecoder)
  }
}
