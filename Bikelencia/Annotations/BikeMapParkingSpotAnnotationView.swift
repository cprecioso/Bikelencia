import MapKit
import SwiftUI
import ValenciaKit

private let SpotImage = Asset.bikeMapParkingSpotImage

class BikeMapParkingSpotAnnotationView: MKAnnotationView {
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

    self.image = SpotImage.image(compatibleWith: self.traitCollection)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    guard previousTraitCollection != nil, previousTraitCollection != self.traitCollection else {
      return
    }

    self.image = SpotImage.image(compatibleWith: self.traitCollection)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
