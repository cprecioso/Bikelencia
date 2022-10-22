import MapKit
import SwiftUI
import ValenciaKit

class BikeMapParkingSpotAnnotation: NSObject, MKAnnotation {
  let spot: BikeParkings.Spot

  init(_ spot: BikeParkings.Spot) {
    self.spot = spot
  }

  var side: Double {
    min(5 + (1.5 * Double(spot.capacity)), 20)
  }

  var size: CGSize {
    let side = self.side
    return CGSize(width: side, height: side)
  }

  var coordinate: CLLocationCoordinate2D {
    spot.coordinate
  }
}
