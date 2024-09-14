import SwiftUI

struct SettingsButton: View {
  @Environment(\.showSettings) var showSettings: (() -> Void)?

  var body: some View {
    Button {
      showSettings?()
    } label: {
      Label("Settings", systemImage: "gear")
    }
    .labelStyle(.iconOnly)
    .buttonStyle(.borderedProminent)
  }
}
