import ClusterMap
import MapKit
import SwiftUI
import ValenciaKit

struct BikeMapSpotAnnotation: MapContent {
  var spot: BikeParkings.Spot
  var setSelection: (BikeParkings.Spot) -> Void

  var body: some MapContent {
    Annotation("Spot", coordinate: spot.coordinate) {
      VisualContent(capacity: spot.capacity)
        .onTapGesture { setSelection(spot) }
    }
    .annotationTitles(.hidden)
  }
}

struct BikeMapClusterAnnotation: MapContent {
  var cluster: ClusterManager<BikeParkings.Spot>.ClusterAnnotation

  var totalCapacity: UInt {
    cluster.memberAnnotations.reduce(0, { $0 + $1.capacity })
  }

  var body: some MapContent {
    Annotation("Cluster", coordinate: cluster.coordinate) {
      VisualContent(
        count: cluster.memberAnnotations.count,
        capacity: totalCapacity
      )
    }
    .annotationTitles(.hidden)
  }
}

private struct VisualContent: View {
  var count: Int?
  var capacity: UInt

  static let minSize = 5.0
  static let maxSize = 25.0

  var side: CGFloat {
    min(Self.minSize + (1.5 * Double(capacity)), Self.maxSize)
  }

  var symbolName: String {
    if let count {
      if count > 50 {
        "arrow.up.left.and.arrow.down.right.square.fill"
      } else {
        "\(count).square.fill"
      }
    } else {
      "bicycle.circle.fill"
    }
  }

  var body: some View {
    Image(systemName: symbolName)
      .resizable()
      .aspectRatio(1, contentMode: .fit)
      .foregroundStyle(Color.white, Color.accent)
      .frame(width: side, height: side, alignment: .center)
  }
}
