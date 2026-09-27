import SwiftUI

struct SettingsButton: View {
  @Environment(\.showSettings) private var showSettings

  var body: some View {
    Button {
      showSettings?()
    } label: {
      Label("Settings", systemImage: "gear")
    }
  }
}
