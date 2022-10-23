import SwiftUI

struct SettingsButton: View {
  @State var isShowingSettings = false

  var body: some View {
    Button {
      isShowingSettings = true
    } label: {
      Label("Settings", systemImage: "gear")
    }
    .labelStyle(.iconOnly)
    .buttonStyle(.borderedProminent)
    .popover(isPresented: $isShowingSettings) {
      SettingsScreen()
    }
  }
}
