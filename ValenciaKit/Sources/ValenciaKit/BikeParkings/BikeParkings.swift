import CoreLocation

public struct BikeParkings {
  public static let empty = BikeParkings(spots: [])

  public var updatedAt = Date.now
  public var spots: [Spot] = []

  public struct Spot {
    init(id: String, coordinate: CLLocationCoordinate2D, capacity: UInt, spotType: String? = nil) {
      self.id = id
      self.coordinate = coordinate
      self.capacity = capacity
      self.spotType = spotType
    }

    public var id: String
    public var coordinate: CLLocationCoordinate2D
    public var capacity: UInt
    public var spotType: String?
  }
}

extension BikeParkings: Codable {}
extension BikeParkings: Equatable {}

extension BikeParkings.Spot: Identifiable {}
extension BikeParkings.Spot: Codable {}
extension BikeParkings.Spot: Equatable {}

#if canImport(MapKit)
  import MapKit

  extension BikeParkings.Spot {
    public var point: MKMapPoint {
      MKMapPoint(coordinate)
    }
  }
#endif

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}

extension CLLocationCoordinate2D: Codable {
  enum CodingKeys: String, CodingKey {
    case latitude, longitude
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let latitude = try container.decode(Double.self, forKey: .latitude)
    let longitude = try container.decode(Double.self, forKey: .longitude)
    self.init(latitude: latitude, longitude: longitude)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)
  }
}
