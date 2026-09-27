import CoreLocation
import MapKit
import SwiftUI

let MapInitialCenter = CLLocationCoordinate2D(
  latitude: 39.518, longitude: -0.424)
let MapInitialRect = MKMapRect(
  origin: MKMapPoint(MapInitialCenter),
  size: MKMapSize(width: 79000, height: 79000))

@MainActor let MapInitialFallbackPosition = MapCameraPosition.rect(MapInitialRect)
@MainActor let PreferredMapPosition = MapCameraPosition.userLocation(
  followsHeading: true,
  fallback: MapInitialFallbackPosition
)
