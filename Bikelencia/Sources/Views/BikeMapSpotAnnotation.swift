import MapKit
import SwiftUI
import ValenciaKit

struct BikeMapSpotAnnotation: MapContent {
  var spot: BikeParkings.Spot
  var onTap: () -> Void
  
  var body: some MapContent {
    Annotation("Spot", coordinate: spot.coordinate) {
      ContentView(spot: spot)
        .onTapGesture(perform: onTap)
    }
    .annotationTitles(.hidden)
  }
}

fileprivate struct ContentView: View {
  var spot: BikeParkings.Spot

  var side: CGFloat {
    min(5 + (1.5 * Double(spot.capacity)), 20)
  }

  var body: some View {
    Circle()
      .fill(Color.accent)
      .frame(width: side, height: side, alignment: .center)
  }
}
