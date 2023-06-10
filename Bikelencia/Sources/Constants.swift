import CoreLocation
import MapKit

enum MapAnnotationIdentifiers: String {
  case parkingSpot = "parking-spot"
}

let MapInitialCenter = CLLocationCoordinate2D(latitude: 39.518, longitude: -0.424)
let MapInitialRect = MKMapRect(
  origin: MKMapPoint(MapInitialCenter),
  size: MKMapSize(width: 79000, height: 79000))
