import CoreLocation
import MapKit
import SwiftUI
import ValenciaKit

struct BikeMapScreen: View {
  @State var position = PreferredMapPosition
  @EnvironmentObject var appModel: AppModel
  @State var selectedSpot: BikeParkings.Spot? = nil

  var body: some View {
    MapView(position: $position)
    .tint(.myLocationDot)
    .ignoresSafeArea()
    .toolbar {
      BikeMapToolbarView(
        isLoading: appModel.isLoading,
        onLocationClick: {
          position = PreferredMapPosition
        })
    }
    .task {
      try? await appModel.updateData(userInitiated: false)
    }
    .sheet(item: $selectedSpot) { spot in
      ParkingSpotScreen(spot: spot)
        .presentationDetents([.medium, .large])
    }
  }
}
