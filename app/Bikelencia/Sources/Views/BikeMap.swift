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

  func zoomToCluster(_ cluster: ClusterManager<BikeParkings.Spot>.ClusterAnnotation) {
    let coordinates = cluster.memberAnnotations.map(\.coordinate)
    guard let minLat = coordinates.map(\.latitude).min(),
          let maxLat = coordinates.map(\.latitude).max(),
          let minLon = coordinates.map(\.longitude).min(),
          let maxLon = coordinates.map(\.longitude).max()
    else { return }
    let padding = 1.3
    let span = MKCoordinateSpan(
      latitudeDelta: (maxLat - minLat) * padding,
      longitudeDelta: (maxLon - minLon) * padding
    )
    let center = CLLocationCoordinate2D(
      latitude: (minLat + maxLat) / 2,
      longitude: (minLon + maxLon) / 2
    )
    withAnimation {
      position = .region(MKCoordinateRegion(center: center, span: span))
    }
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
          BikeMapClusterAnnotation(cluster: cluster, zoomIn: { zoomToCluster(cluster) })
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
