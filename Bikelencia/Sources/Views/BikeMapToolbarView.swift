import CoreLocationUI
import SwiftUI

struct BikeMapToolbarView: ToolbarContent {
  var isLoading: Bool
  var onLocationClick: (() -> Void) = {}
  
  @Environment(\.locationManager) var locationManager: LocationManager

  var locationButton: some View {
    let button = LocationButton(action: onLocationClick)
      .foregroundColor(.white)
      .tint(.myLocationDot)
      .cornerRadius(5)
      .symbolVariant(.fill)
      .buttonStyle(.bordered)

    return Group {
      if locationManager.hasLocation {
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
