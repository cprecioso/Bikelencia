import CoreLocation

private let APPLE_MAPS_BASE_URL = URLComponents(string: "http://maps.apple.com/")!

private enum QueryItemNames: String {
  case LatitudeLongitude = "ll"
  case Query = "q"
}

extension CLLocationCoordinate2D {
  func getAppleMapsURL(name: String? = nil) -> URL {
    var url = APPLE_MAPS_BASE_URL

    url.queryItems = .from([
      QueryItemNames.LatitudeLongitude: "\(latitude),\(longitude)",
      QueryItemNames.Query: name,
    ])

    return url.url!
  }
}
