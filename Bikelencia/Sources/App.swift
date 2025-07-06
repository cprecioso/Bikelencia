import SwiftUI
import BikelenciaCore

extension EnvironmentValues {
  @Entry var showSettings: (() -> Void)?
}

@main
struct BikelenciaApp: App {
  @State var isShowingSettings = false
  @State var spotsController = SpotsController()
  @State var locationManager = LocationManager()

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
      .environment(locationManager)
      .environment(\.showSettings, { isShowingSettings = true })
      .environment(spotsController)
      .task(id: spotsController.needsUpdate, priority: .background) {
        if spotsController.needsUpdate {
          try? await spotsController.updateData(userInitiated: false)
        }
      }
    }
  }
}
