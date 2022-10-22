import SwiftUI
import CoreLocation

struct ParkingSpotInfoView: View {
  var coordinate: CLLocationCoordinate2D

  @State var placemark: CLPlacemark?
  @State var isLoading = true

  var placemarkString: String? {
    guard let placemark else { return nil }
    if let name = placemark.name {
      return name
    }

    if let thoroughfare = placemark.thoroughfare {
      if let subThoroughfare = placemark.subThoroughfare {
        return "\(thoroughfare) (\(subThoroughfare)"
      } else {
        return thoroughfare
      }
    }

    return nil
  }

  @Sendable
  func updatePlacemark() async {
    isLoading = true
    defer {
      isLoading = false
    }

    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let placemarks = try? await CLGeocoder().reverseGeocodeLocation(location)

    withAnimation {
      placemark = placemarks?.first
    }
  }

  var body: some View {
    if let placemarkString {
      Text(placemarkString)
    } else {
      if isLoading {
        Label {
          Text("Loading address")
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

