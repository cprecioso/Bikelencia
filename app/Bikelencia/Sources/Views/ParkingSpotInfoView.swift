import CoreLocation
import MapKit
import SwiftUI

struct ParkingSpotInfoView: View {
  var coordinate: CLLocationCoordinate2D

  @State var mapItem: MKMapItem?
  @State var isLoading = true

  var placemarkText: String? {
    mapItem?.name
      ?? mapItem?.addressRepresentations?.fullAddress(
        includingRegion: false,
        singleLine: true
      )
  }

  @Sendable
  func updatePlacemark() async {
    isLoading = true
    defer {
      isLoading = false
    }

    let location = CLLocation(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude
    )
    let mapItems = try? await MKReverseGeocodingRequest(location: location)?
      .mapItems

    withAnimation {
      mapItem = mapItems?.first
    }
  }

  var body: some View {
    if let placemarkText {
      Text(placemarkText)
    } else {
      if isLoading {
        Label {
          Text("Loading address...")
        } icon: {
          ProgressView()
        }
        .task(updatePlacemark)
      } else {
        Label("No address found", systemImage: "exclamationmark.circle")
      }
    }
  }
}
