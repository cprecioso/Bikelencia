import SwiftUI

struct SettingsScreen: View {
  @ObservedObject var appModel = AppModel.shared

  @State var currentDate = Date.now

  var settingsURL: URL? {
    URL(string: UIApplication.openSettingsURLString)
  }

  let relativeDateTimeFormatter = RelativeDateTimeFormatter()

  var body: some View {
    List {
      if let settingsURL {
        Section {
          makeListRow("Application settings", destination: settingsURL, image: "gearshape")
        } footer: {
          Text(
            "For the best possible experience, enable location when in use, with full accuracy. However, the application can work with any settings."
          )
        }
      }

      Section {
        makeListRow(
          "Website", destination: URL(string: "https://precioso.design")!, image: "safari")
        makeListRow(
          "Contact", destination: URL(string: "mailto:bikelencia@precioso.design")!,
          image: "envelope")
      }

      Section {
        makeListRow(
          "Ajuntament de València - Dades Obertes",
          destination: URL(string: "http://www.valencia.es/dadesobertes/")!,
          image: "arrow.forward.circle")

        if let updatedAt = appModel.bikeParkings?.updatedAt {
          let updatedAtString = relativeDateTimeFormatter.localizedString(
            for: updatedAt,
            relativeTo: currentDate
          )
          makeListRow("Last modified", content: updatedAtString)
        }
      } header: {
        Text("Source data")
      } footer: {
        VStack {
          if let fetchedAt = appModel.bikeParkings?.fetchedAt {
            let fetchedAtString = relativeDateTimeFormatter.localizedString(
              for: fetchedAt,
              relativeTo: currentDate
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
