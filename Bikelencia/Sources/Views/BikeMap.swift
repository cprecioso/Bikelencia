import MapKit
import SwiftUI
import ValenciaKit
import BikelenciaCore

struct MapView: View {
  @Binding var position: MapCameraPosition
  @Binding var selectedSpot: BikeParkings.Spot?
  @Environment(LocationManager.self) private var locationManager
  @Environment(SpotsController.self) private var spotsController
  var mapScope: Namespace.ID

  func setSelected(_ spot: BikeParkings.Spot) {
    self.selectedSpot = spot
  }

  var body: some View {
    Map(
      position: $position,
      interactionModes: .all.subtracting(.pitch),
      scope: mapScope
    ) {
      UserAnnotation()
      ForEach(spotsController.bikeParkings.value?.spots ?? []) { spot in
        BikeMapSpotAnnotation(spot: spot, setSelection: setSelected)
      }
    }
    .mapStyle(.standard(pointsOfInterest: .excludingAll, showsTraffic: true))
    .tint(.myLocationDot)
  }
}
