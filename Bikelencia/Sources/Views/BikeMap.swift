import BikelenciaCore
import MapKit
import SwiftUI
import ValenciaKit

private struct SpotsMapContent: MapContent {
  var spots: [BikeParkings.Spot]
  var setSelected: (BikeParkings.Spot) -> Void

  var body: some MapContent {
    ForEach(spots, id: \.id) { spot in
      BikeMapSpotAnnotation(spot: spot, setSelection: setSelected)
    }
  }
}

struct MapView: View {
  @Binding var position: MapCameraPosition
  @Binding var selectedSpot: BikeParkings.Spot?
  @Environment(LocationManager.self) private var locationManager
  @Environment(SpotsController.self) private var spotsController

  func setSelected(_ spot: BikeParkings.Spot) {
    self.selectedSpot = spot
  }

  var body: some View {
    Map(
      position: $position,
      interactionModes: .all.subtracting(.pitch),
    ) {
      UserAnnotation()
      SpotsMapContent(
        spots: spotsController.bikeParkings.value?.spots ?? [],
        setSelected: setSelected
      )
    }
    .mapControls {
      if locationManager.hasLocation {
        MapUserLocationButton()
      }
    }
    .mapStyle(.standard(pointsOfInterest: .excludingAll, showsTraffic: true))
    .tint(.myLocationDot)
  }
}
