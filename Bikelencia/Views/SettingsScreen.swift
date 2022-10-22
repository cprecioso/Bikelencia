import SwiftUI

struct SettingsScreen: View {
  @Environment(\.openURL) private var openURL

  var settingsURL: URL? {
    URL(string: UIApplication.openSettingsURLString)
  }

  var body: some View {
    List {
      if let settingsURL = settingsURL {
        Section {
          Button("Application settings") {
            openURL(settingsURL)
          }
        } footer: {
          Text(
            "For the best possible experience, enable location when in use, with full accuracy. However, the application can work with any settings."
          )
        }
      }

      Section {
        Button("Website") {
          openURL(URL(string: "https://precioso.design")!)
        }
      }
    }
  }
}
