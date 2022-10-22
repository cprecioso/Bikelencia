import Foundation

extension [URLQueryItem] {
  static func from(_ queryItems: KeyValuePairs<String, String?>) -> Self {
    return queryItems.map { URLQueryItem(name: $0, value: $1) }
  }

  static func from(_ queryItems: KeyValuePairs<any RawRepresentable<String>, String?>) -> Self {
    return queryItems.map { URLQueryItem(name: $0.rawValue, value: $1) }
  }
}

extension [URLQueryItem]: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, String?)...) {
    self = elements.map { URLQueryItem(name: $0.0, value: $0.1) }
  }
}
