import BackgroundAssets
import BikelenciaCore
import SwiftUI

extension EnvironmentValues {
  @Entry var showSettings: (() -> Void)?
}

@main
struct BikelenciaApp: App {
  @State var isShowingSettings = false
  @State var spotsController = SpotsController()
  @State var locationManager = LocationManager()

  private func promotePendingDownloads() {
    Task {
      guard let downloads = try? await BADownloadManager.shared.currentDownloads else { return }
      for download in downloads {
        try? BADownloadManager.shared.startForegroundDownload(download)
      }
    }
  }

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
      .onAppear {
        if locationManager.authorizationStatus == .notDetermined {
          locationManager.requestLocationPermission()
        }
        promotePendingDownloads()
      }
      .task(id: spotsController.needsUpdate, priority: .background) {
        if spotsController.needsUpdate {
          try? await spotsController.updateData(userInitiated: false)
        }
      }
    }
  }
}
