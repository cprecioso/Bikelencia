import SwiftUI

struct SettingsScreen: View {
  @ObservedObject var appModel = AppModel.shared

  var settingsURL: URL? {
    URL(string: UIApplication.openSettingsURLString)
  }

  let relativeDateTimeFormatter = RelativeDateTimeFormatter()

  var lastUpdatedString: String? {
    guard
      let updatedAt = appModel.bikeParkings?.updatedAt
    else {
      return nil
    }

    return relativeDateTimeFormatter.localizedString(
      for: updatedAt,
      relativeTo: Date.now
    )
  }

  var body: some View {
    List {
      if let settingsURL {
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
      } footer: {
        if let lastUpdatedString {
          Text("Last updated: \(lastUpdatedString)")
        } else {
          Text("Not yet updated")
        }
      }
    }
    .navigationTitle("Settings")
  }
}
