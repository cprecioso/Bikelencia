import CoreLocationUI
import MapKit
import SwiftUI

struct BikeMapToolbarView: ToolbarContent {
  var isLoading: Bool
  var onLocationClick: (() -> Void) = {}
  @Environment(LocationManager.self) private var locationManager

  var locationButton: some View {
    LocationButton(action: onLocationClick)
      .labelStyle(.titleAndIcon)
      .cornerRadius(5)
      .symbolVariant(.fill)
      .foregroundColor(.white)
      .tint(.accent)
  }

  var body: some ToolbarContent {
    if !locationManager.hasLocation {
      ToolbarItem(placement: .automatic) {
        locationButton
      }
    }

    if isLoading {
      ToolbarItem(placement: .topBarTrailing) {
        ProgressView()
      }
    }

    ToolbarItem(placement: .secondaryAction) {
      SettingsButton()
    }
  }
}
