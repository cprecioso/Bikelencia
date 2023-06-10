import SwiftUI

struct SettingsButton: View {
  @Environment(\.isShowingSettings) var isShowing: Binding<Bool>

  var body: some View {
    Button {
      isShowing.wrappedValue = true
    } label: {
      Label("Settings", systemImage: "gear")
    }
    .labelStyle(.iconOnly)
    .buttonStyle(.borderedProminent)
  }
}
