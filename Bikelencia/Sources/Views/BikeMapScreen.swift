import CoreLocation
import MapKit
import SwiftUI
import ValenciaKit
import BikelenciaCore

struct BikeMapScreen: View {
  @State var position = PreferredMapPosition
  @State var selectedSpot: BikeParkings.Spot? = nil
  @Environment(SpotsController.self) private var spotsController
  @Namespace private var mapScope

  var body: some View {
      MapView(
        position: $position,
        selectedSpot: $selectedSpot,
        mapScope: mapScope
      )
      .tint(.myLocationDot)
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
