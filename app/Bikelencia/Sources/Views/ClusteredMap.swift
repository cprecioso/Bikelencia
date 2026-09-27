import ClusterMap
import ClusterMapSwiftUI
import MapKit
import SwiftUI

typealias Clusterable = CoordinateIdentifiable & Hashable & Identifiable & Sendable

struct ClusteredMap<Item: Clusterable, Map: View>: View {
  typealias Cluster = ClusterManager<Item>.ClusterAnnotation

  var items: [Item]
  var mapView: ([Item], [Cluster]) -> Map

  @State private var clusterManager = ClusterManager<Item>(
    configuration: .init(
      minCountForClustering: 4,
      shouldRemoveInvisibleAnnotations: true,
      shouldDistributeAnnotationsOnSameCoordinate: false,
      clusterPosition: .nearCenter
    )
  )
  @State private var mapSize = CGSize.zero
  @State private var coordinateRegion = MKCoordinateRegion()

  @State private var annotations: [Item] = []
  @State private var clusters: [Cluster] = []

  var body: some View {
    mapView(
      annotations,
      clusters
    )
    .onMapCameraChange(frequency: .onEnd) { context in
      coordinateRegion = context.region
      updateClusters()
    }
    .readSize { size in
      self.mapSize = size
      updateClusters()
    }
    .onChange(of: items, initial: true) { _, newValue in
      Task {
        await clusterManager.removeAll()
        await clusterManager.add(newValue)
        updateClusters()
      }
    }
  }

  func updateClusters() {
    Task {
      let difference = await clusterManager.reload(
        mapViewSize: mapSize,
        coordinateRegion: coordinateRegion
      )

      for removal in difference.removals {
        switch removal {
        case .annotation(let annotation):
          annotations.removeAll { $0 == annotation }
        case .cluster(let cluster):
          clusters.removeAll { $0.id == cluster.id }
        }
      }

      for insertion in difference.insertions {
        switch insertion {
        case .annotation(let annotation):
          annotations.append(annotation)
        case .cluster(let cluster):
          clusters.append(cluster)
        }
      }
    }
  }
}
