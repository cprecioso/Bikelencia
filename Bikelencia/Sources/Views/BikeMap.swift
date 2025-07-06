import MapKit
import SwiftUI
import ValenciaKit

struct MapView: View {
  @Binding var position: MapCameraPosition
  @State var selectedSpot: BikeParkings.Spot? = nil
  @Environment(LocationManager.self) private var locationManager
  @Environment(SpotsController.self) private var spotsController
  var mapScope: Namespace.ID

  var body: some View {
    Map(
      position: $position,
      interactionModes: .all.subtracting(.pitch),
      scope: mapScope
    ) {
      UserAnnotation()
      ForEach(spotsController.bikeParkings.value?.spots ?? []) { spot in
        BikeMapSpotAnnotation(spot: spot, onTap: { selectedSpot = spot })
      }
    }
    .mapStyle(.standard(pointsOfInterest: .excludingAll, showsTraffic: true))
    .tint(.myLocationDot)
  }
}
