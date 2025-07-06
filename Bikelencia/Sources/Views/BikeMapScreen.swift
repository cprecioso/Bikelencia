import CoreLocation
import MapKit
import SwiftUI
import ValenciaKit

struct BikeMapScreen: View {
  @State var position = PreferredMapPosition
  @State var selectedSpot: BikeParkings.Spot? = nil
  
  @Environment(SpotsController.self) private var spotsController
  @Namespace var mapScope

  var body: some View {
    MapView(position: $position, mapScope: mapScope)
    .tint(.myLocationDot)
    .ignoresSafeArea()
    .toolbar {
      BikeMapToolbarView(
        isLoading: spotsController.isLoading,
        onLocationClick: {
          position = PreferredMapPosition
        },
        mapScope: mapScope
      )
    }
    .sheet(item: $selectedSpot) { spot in
      ParkingSpotScreen(spot: spot)
        .presentationDetents([.medium, .large])
    }
    .mapScope(mapScope)
  }
}
