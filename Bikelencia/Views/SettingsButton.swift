import SwiftUI

struct SettingsButton: View {
  @State var isShowingSettings = false

  var body: some View {
    Button("Settings") {
      isShowingSettings = true
    }
    .buttonStyle(.bordered)
    .popover(isPresented: $isShowingSettings) {
      SettingsScreen()
    }
  }
}
