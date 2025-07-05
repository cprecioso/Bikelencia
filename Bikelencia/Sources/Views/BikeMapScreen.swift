import CoreLocation
import MapKit
import SwiftUI
import ValenciaKit

struct BikeMapScreen: View {
  @State var position = PreferredMapPosition
  @State var selectedSpot: BikeParkings.Spot? = nil
  
  @Environment(SpotsController.self) private var spotsController

  var body: some View {
    MapView(position: $position)
    .tint(.myLocationDot)
    .ignoresSafeArea()
    .toolbar {
      BikeMapToolbarView(
        isLoading: spotsController.isLoading,
        onLocationClick: {
          position = PreferredMapPosition
        })
    }
    .sheet(item: $selectedSpot) { spot in
      ParkingSpotScreen(spot: spot)
        .presentationDetents([.medium, .large])
    }
  }
}
