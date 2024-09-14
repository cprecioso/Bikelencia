import SwiftUI

extension EnvironmentValues {
  @Entry var showSettings: (() -> Void)?
}

@main
struct BikelenciaApp: App {
  @State var isShowingSettings = false
  @StateObject var appModel = AppModel()

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        BikeMapScreen()
          .sheet(isPresented: $isShowingSettings) {
            NavigationStack {
              SettingsScreen()
                .toolbar {
                  ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                      isShowingSettings = false
                    }
                  }
                }
            }
          }
      }
      .environmentObject(appModel)
      .environment(\.showSettings, { isShowingSettings = true })
      .task {
        try? await appModel.updateData(userInitiated: false)
      }
    }
  }
}
