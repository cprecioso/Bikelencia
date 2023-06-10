import SwiftUI

private struct IsShowingSettingsKey: EnvironmentKey {
  static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
  var isShowingSettings: Binding<Bool> {
    get { self[IsShowingSettingsKey.self] }
    set { self[IsShowingSettingsKey.self] = newValue }
  }
}

@main
struct BikelenciaApp: App {
  @State var isShowingSettings = false

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
      .environment(\.isShowingSettings, $isShowingSettings)
    }
  }
}
