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

  var body: some View {
    MapView(
      position: $position,
      selectedSpot: $selectedSpot,
    )
    .toolbar {
      BikeMapToolbarView(
        isLoading: spotsController.isLoading,
        onLocationClick: {
          position = PreferredMapPosition
        },
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
  }
}
