import CoreLocation
import CoreLocationUI
import SwiftUI

class ObserveLocation: NSObject, CLLocationManagerDelegate, ObservableObject {
  let manager = CLLocationManager()

  @Published var authorizationStatus: CLAuthorizationStatus

  override init() {
    authorizationStatus = manager.authorizationStatus
    super.init()
    manager.delegate = self
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
  }
}

struct BikeMapToolbarView: ToolbarContent {
  var isLoading: Bool
  var onLocationClick: (() -> Void) = {}

  @ObservedObject var location = ObserveLocation()

  var hasLocation: Bool {
    switch location.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse: return true
    default: return false
    }
  }

  var locationButton: some View {
    let button = LocationButton(action: onLocationClick)
      .foregroundColor(.white)
      .tint(.myLocationDot)
      .cornerRadius(5)
      .symbolVariant(.fill)
      .buttonStyle(.bordered)

    return Group {
      if hasLocation {
        button.labelStyle(.iconOnly)
      } else {
        button.labelStyle(.titleAndIcon)
      }
    }
  }

  var body: some ToolbarContent {
    Group {
      ToolbarItem(placement: .navigationBarLeading) {
        locationButton
      }

      if isLoading {
        ToolbarItem(placement: .navigationBarTrailing) {
          ProgressView()
        }
      }

      ToolbarItem(placement: .secondaryAction) {
        SettingsButton()
      }
    }
  }
}
