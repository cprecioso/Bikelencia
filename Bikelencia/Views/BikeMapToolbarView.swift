import CoreLocationUI
import SwiftUI

struct BikeMapToolbarView: ToolbarContent {
  var isLoading: Bool
  var onLocationClick: (() -> Void) = {}

  var locationButton: some View {
    LocationButton(action: onLocationClick)
      .foregroundColor(.white)
      .tint(.accentColor)
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
