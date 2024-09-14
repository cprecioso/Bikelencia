import CoreLocation
import SwiftUI

extension EnvironmentValues {
  @Entry var locationManager = LocationManager()
}

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
  private let manager = CLLocationManager()

  var authorizationStatus: CLAuthorizationStatus
  var hasLocation: Bool {
    switch authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse: return true
    default: return false
    }
  }

  override init() {
    authorizationStatus = manager.authorizationStatus
    super.init()
    manager.delegate = self
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
  }
}
