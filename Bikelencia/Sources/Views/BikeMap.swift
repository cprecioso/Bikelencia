import BikelenciaCore
import ClusterMap
import MapKit
import SwiftUI
import ValenciaKit

extension BikeParkings.Spot: ClusterMap.CoordinateIdentifiable {}

struct MapView: View {
  @Binding var position: MapCameraPosition
  @Binding var selectedSpot: BikeParkings.Spot?
  @Environment(SpotsController.self) private var spotsController

  private var spots: [BikeParkings.Spot] {
    spotsController.bikeParkings.value?.spots ?? []
  }

  func setSelected(_ spot: BikeParkings.Spot) {
    self.selectedSpot = spot
  }

  var body: some View {
    ClusteredMap(items: spots) { items, clusters in
      Map(
        position: $position,
        interactionModes: .all.subtracting(.pitch),
      ) {
        UserAnnotation()
        ForEach(items) { spot in
          BikeMapSpotAnnotation(spot: spot, setSelection: setSelected)
        }
        ForEach(clusters) { cluster in
          BikeMapClusterAnnotation(cluster: cluster)
        }
      }
      .mapControls {
        MapUserLocationButton()
        MapCompass()
        MapScaleView()
      }
      .mapStyle(.standard(pointsOfInterest: .excludingAll, showsTraffic: true))
      .tint(.myLocationDot)
    }
  }
}
