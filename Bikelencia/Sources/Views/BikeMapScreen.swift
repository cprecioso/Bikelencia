import BikelenciaCore
import CoreLocation
import MapKit
import SwiftUI
import ValenciaKit

struct BikeMapScreen: View {
  @State var position = PreferredMapPosition
  @State var selectedSpot: BikeParkings.Spot? = nil
  @Environment(SpotsController.self) private var spotsController
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
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
        .presentationDetents(
          horizontalSizeClass == .compact
            ? [.medium, .large]
            : []
        )
    }
    .mapScope(mapScope)
  }
}
