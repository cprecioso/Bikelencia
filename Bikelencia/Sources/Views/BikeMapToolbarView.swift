import CoreLocationUI
import MapKit
import SwiftUI

struct BikeMapToolbarView: ToolbarContent {
  var isLoading: Bool
  var onLocationClick: (() -> Void) = {}

  @Environment(LocationManager.self) private var locationManager
  var mapScope: Namespace.ID

  var locationButton: some View {
    Group {
      if locationManager.hasLocation {
        MapUserLocationButton(scope: mapScope)
      } else {
        LocationButton(action: onLocationClick)
          .labelStyle(.titleAndIcon)
      }
    }
    .foregroundColor(.white)
    .tint(.myLocationDot)
    .cornerRadius(5)
    .symbolVariant(.fill)
    .buttonStyle(.bordered)
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
