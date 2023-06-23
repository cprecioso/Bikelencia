import MapKit
import SwiftUI
import ValenciaKit

struct ParkingSpotScreen: View {
  var spot: BikeParkings.Spot

  @State var scene: MKLookAroundScene?
  @State var isLoading = true

  @Sendable
  func updateScene() async {
    isLoading = true
    defer { isLoading = false }
    let request = MKLookAroundSceneRequest(coordinate: spot.coordinate)
    let scene = try? await request.scene
    withAnimation {
      self.scene = scene
    }
  }

  @Environment(\.openURL) private var openURL

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        if let scene {
          LookAround(scene: scene, showsRoadLabels: true, badgePosition: .bottomTrailing)
            .ignoresSafeArea()
        }

        List {
          Section(BikelenciaStrings.Localizable.spotInformationHeader) {
            if let spotType = spot.spotType {
              HStack {
                Text(BikelenciaStrings.Localizable.bikeParkingType)
                Spacer()
                Text(spotType)
              }
            }
            HStack {
              Text(BikelenciaStrings.Localizable.capacity)
              Spacer()
              Text(BikelenciaStrings.Localizable.bikeAmount(Int(spot.capacity)))
            }
          }

          Section(BikelenciaStrings.Localizable.locationHeader) {
            ParkingSpotInfoView(coordinate: spot.coordinate)
            Button(BikelenciaStrings.Localizable.seeInMapsLink) {
              openURL(
                spot.coordinate.getAppleMapsURL(
                  name: BikelenciaStrings.Localizable.bikeParkingPlaceNameInMaps))
            }
          }
        }
        .listStyle(.grouped)
      }
      .navigationTitle(BikelenciaStrings.Localizable.spotScreenHeader)
      .toolbar(.hidden)
      .task(updateScene)
    }
  }
}
