import SwiftUI

struct SettingsScreen: View {
  @ObservedObject var appModel = AppModel.shared

  var settingsURL: URL? {
    URL(string: UIApplication.openSettingsURLString)
  }

  let relativeDateTimeFormatter = RelativeDateTimeFormatter()

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
      }

      Section {
        Link(
          "Ajuntament de València - Dades Obertes",
          destination: URL(string: "http://www.valencia.es/dadesobertes/")!)

        if let updatedAt = appModel.bikeParkings?.updatedAt {
          let updatedAtString = relativeDateTimeFormatter.localizedString(
            for: updatedAt,
            relativeTo: Date.now
          )
          HStack {
            Text("Last modified")
            Spacer()
            Text(updatedAtString)
          }
        }
      } header: {
        Text("Source data")
      } footer: {
        VStack {
          if let fetchedAt = appModel.bikeParkings?.fetchedAt {
            let fetchedAtString = relativeDateTimeFormatter.localizedString(
              for: fetchedAt,
              relativeTo: Date.now
            )
            Text("Last updated: \(fetchedAtString)")
        } else {
          Text("Not yet updated")
        }
      }
    }
    }
    .refreshable {
      try? await appModel.updateData()
    }
    .navigationTitle("Settings")
  }
}
