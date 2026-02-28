import SwiftUI

struct BikeMapToolbarView: ToolbarContent {
  var isLoading: Bool

  var body: some ToolbarContent {
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
