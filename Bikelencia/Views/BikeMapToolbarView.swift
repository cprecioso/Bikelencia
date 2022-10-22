import CoreLocationUI
import SwiftUI

struct BikeMapToolbarView: View {
  var isLoading: Bool
  var onLocationClick: (() -> Void) = {}

  var locationButton: some View {
    LocationButton(action: onLocationClick)
      .foregroundColor(Color.white)
      .tint(.accentColor)
      .cornerRadius(5)
  }

  var body: some View {
    HStack(alignment: .center) {
      locationButton

      Spacer()

      if isLoading {
        ProgressView()
          .padding(.horizontal)
      }

      SettingsButton()
    }
    .padding()
  }
}
