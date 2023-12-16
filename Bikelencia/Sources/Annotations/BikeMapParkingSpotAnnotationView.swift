import MapKit
import SwiftUI
import ValenciaKit

class BikeMapParkingSpotAnnotationView: MKAnnotationView {
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    self.image = UIImage.bikeMapParkingSpot
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    guard previousTraitCollection != nil, previousTraitCollection != self.traitCollection else {
      return
    }
    let oldFrame = self.frame
    self.image = UIImage.bikeMapParkingSpot
    self.frame = oldFrame
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
