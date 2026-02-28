import CoreLocation
@_exported import CoreLocationCodable
import HelperCoders
import MetaCodable

@Codable
public struct BikeParkings: Sendable {
  @CodedBy(LenientISO8601DateCoder())
  public var updatedAt: Date = Date.now
  public var spots: [Spot] = []

  public struct Spot: Sendable {
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

extension BikeParkings {
  public static let empty = BikeParkings(spots: [])
}

extension BikeParkings: Equatable {}

extension BikeParkings.Spot: Identifiable {}
extension BikeParkings.Spot: Codable {}
extension BikeParkings.Spot: Equatable {}
extension BikeParkings.Spot: Hashable {}

#if canImport(MapKit)
  import MapKit

  extension BikeParkings.Spot {
    public var point: MKMapPoint {
      MKMapPoint(coordinate)
    }
  }
#endif

