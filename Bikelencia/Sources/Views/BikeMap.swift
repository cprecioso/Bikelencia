import MapKit
import SwiftUI
import ValenciaKit

struct MapView: View {
  @Binding var position: MapCameraPosition
  @EnvironmentObject var appModel: AppModel
  @State var selectedSpot: BikeParkings.Spot? = nil
  @Environment(\.locationManager) var locationManager: LocationManager

  var body: some View {
    Map(
      position: $position,
      interactionModes: .all
    ) {
      if locationManager.hasLocation {
        UserAnnotation()
      }
      ForEach(appModel.bikeParkings?.spots ?? []) { spot in
        BikeMapSpotAnnotation(spot: spot, onTap: { selectedSpot = spot })
      }
    }
    .mapStyle(.standard(pointsOfInterest: .excludingAll, showsTraffic: true))
    .mapControlVisibility(.automatic)
    .tint(.myLocationDot)
  }
}
