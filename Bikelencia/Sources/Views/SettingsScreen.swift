import SwiftUI
import BikelenciaCore

struct SettingsScreen: View {
  @Environment(SpotsController.self) private var spotsController

  var settingsURL: URL? {
    URL(string: UIApplication.openSettingsURLString)
  }

  var body: some View {
    List {
      if let settingsURL {
        Section {
          makeListRow(
            Text("Application Settings"), destination: settingsURL,
            image: "gearshape")
        } footer: {
          Text(
            "For the best possible experience, enable **location when in use**, with **full accuracy**. However, the application can work with any settings."
          )
        }
      }

      Section {
        makeListRow(
          Text("Website"),
          destination: URL(string: "https://bikelencia.precioso.design")!,
          image: "safari"
        )

        makeListRow(
          Text("Contact"),
          destination: URL(string: "mailto:bikelencia@precioso.design")!,
          image: "envelope")
      }

      Section {
        makeListRow(
          Text(verbatim: "Ajuntament de València - Dades Obertes"),
          destination: URL(string: "http://www.valencia.es/dadesobertes/")!,
          image: "arrow.forward.circle")

        if let updatedAt = spotsController.bikeParkings.value?.updatedAt {
          makeListRow(Text("Last modified")) {
            Text(updatedAt, style: .date)
          }
        }
      } header: {
        Text("Data source")
      } footer: {
        if let fetchedAt = spotsController.bikeParkings.value?.fetchedAt {
          Text("Last updated \(fetchedAt, style: .relative) ago")
        } else {
          Text("Not yet updated. Pull down to update the data.")
        }
      }
    }
    .refreshable {
      try? await spotsController.updateData(userInitiated: true)
    }
    .navigationTitle("Settings")
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    SettingsScreen()
  }
}
