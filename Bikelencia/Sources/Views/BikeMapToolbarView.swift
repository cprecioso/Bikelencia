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
          .matchedGeometryEffect(id: "location-button", in: animationNamespace)
      } else {
        LocationButton(action: onLocationClick)
          .labelStyle(.titleAndIcon)
          .cornerRadius(5)
          .symbolVariant(.fill)
          .matchedGeometryEffect(id: "location-button", in: animationNamespace)
      }
    }
    .foregroundColor(.white)
    .tint(.accent)
    .onChange(of: locationManager.hasLocation, initial: true) { _, newValue in
      withAnimation {
        self.hasLocation = newValue
      }
    }
  }

  var body: some ToolbarContent {
    Group {
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
}
