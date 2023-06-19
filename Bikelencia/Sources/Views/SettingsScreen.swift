import SwiftUI

struct SettingsScreen: View {
  @ObservedObject var appModel = AppModel.shared

  var settingsURL: URL? {
    URL(string: UIApplication.openSettingsURLString)
  }

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
          makeListRow("Last modified") {
            Text(updatedAt, style: .date)
          }
        }
      } header: {
        Text("Source data")
      } footer: {
        if let fetchedAt = appModel.bikeParkings?.fetchedAt {
          Text("Last updated \(Text(fetchedAt, style: .relative)) ago")
        } else {
          Text("Not yet updated")
        }
      }
    }
    .refreshable {
      try? await appModel.updateData()
    }
    .navigationTitle("Settings")
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    SettingsScreen()
  }
}
