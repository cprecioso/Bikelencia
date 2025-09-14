import CoreLocationUI
import MapKit
import SwiftUI

struct BikeMapToolbarView: ToolbarContent {
  var isLoading: Bool
  var onLocationClick: (() -> Void) = {}
  var mapScope: Namespace.ID
  @Namespace private var animationNamespace
  @State private var hasLocation: Bool = true

  @Environment(LocationManager.self) private var locationManager

  var locationButton: some View {
    Group {
      if hasLocation {
        MapUserLocationButton(scope: mapScope)
      } else {
        LocationButton(action: onLocationClick)
          .labelStyle(.titleAndIcon)
          .cornerRadius(5)
          .symbolVariant(.fill)
      }
    }
    .foregroundColor(.white)
    .tint(.accent)
  }

  var body: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      locationButton
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
