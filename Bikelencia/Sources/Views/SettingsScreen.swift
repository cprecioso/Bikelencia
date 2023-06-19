import SwiftUI

struct SettingsScreen: View {
  var settingsURL: URL? {
    URL(string: UIApplication.openSettingsURLString)
  }

  var body: some View {
    List {
      if let settingsURL = settingsURL {
        Section {
          Link("Application settings", destination: settingsURL)
        } footer: {
          Text(
            "For the best possible experience, enable location when in use, with full accuracy. However, the application can work with any settings."
          )
        }
      }

      Section {
        Link("Website", destination: URL(string: "https://precioso.design")!)
        Link("Contact", destination: URL(string: "mailto:bikelencia@precioso.design")!)
        VStack(alignment: .leading) {
          Text("Source of the data")
          Link("Ajuntament de València - Dades Obertes", destination: URL(string: "http://www.valencia.es/dadesobertes/")!)
        }
      }
    }
    .navigationTitle("Settings")
  }
}
