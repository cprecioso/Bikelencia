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
          makeListRow(
            BikelenciaStrings.Localizable.applicationSettingsButton, destination: settingsURL,
            image: "gearshape")
        } footer: {
          Text(
            try! AttributedString(
              markdown: BikelenciaStrings.Localizable.locationSettingsGuidance
            ))
        }
      }

      Section {
        makeListRow(
          BikelenciaStrings.Localizable.websiteLink,
          destination: URL(string: "https://precioso.design")!,
          image: "safari")
        makeListRow(
          BikelenciaStrings.Localizable.contactLink,
          destination: URL(string: "mailto:bikelencia@precioso.design")!,
          image: "envelope")
      }

      Section {
        makeListRow(
          "Ajuntament de València - Dades Obertes",
          destination: URL(string: "http://www.valencia.es/dadesobertes/")!,
          image: "arrow.forward.circle")

        if let updatedAt = appModel.bikeParkings?.updatedAt {
          makeListRow(BikelenciaStrings.Localizable.lastModifiedLabel) {
            Text(updatedAt, style: .date)
          }
        }
      } header: {
        Text(BikelenciaStrings.Localizable.dataSourceHeader)
      } footer: {
        if let fetchedAt = appModel.bikeParkings?.fetchedAt {
          Text("Last Updated \(fetchedAt, style: .relative) Ago Text")
        } else {
          Text(BikelenciaStrings.Localizable.notUpdatedText)
        }
      }
    }
    .refreshable {
      try? await appModel.updateData()
    }
    .navigationTitle(BikelenciaStrings.Localizable.settingsHeader)
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    SettingsScreen()
  }
}
