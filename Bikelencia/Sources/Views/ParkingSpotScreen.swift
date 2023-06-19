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
          Section("Spot information") {
            if let spotType = spot.spotType {
              HStack {
                Text("Type")
                Spacer()
                Text(spotType)
              }
            }
            HStack {
              Text("Capacity")
              Spacer()
              Text("\(spot.capacity) bikes")
            }
          }

          Section("Location") {
            ParkingSpotInfoView(coordinate: spot.coordinate)
            Button("See in Maps") {
              openURL(spot.coordinate.getAppleMapsURL(name: "Bike parking"))
            }
          }
        }
        .listStyle(.grouped)
      }
      .navigationTitle("Parking spot")
      .toolbar(.hidden)
      .task(updateScene)
    }
  }
}
