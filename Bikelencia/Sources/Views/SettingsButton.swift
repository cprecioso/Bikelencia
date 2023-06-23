import SwiftUI

struct SettingsButton: View {
  @Environment(\.isShowingSettings) var isShowing: Binding<Bool>

  var body: some View {
    Button {
      isShowing.wrappedValue = true
    } label: {
      Label(BikelenciaStrings.Localizable.settingsButton, systemImage: "gear")
    }
    .labelStyle(.iconOnly)
    .buttonStyle(.borderedProminent)
  }
}
