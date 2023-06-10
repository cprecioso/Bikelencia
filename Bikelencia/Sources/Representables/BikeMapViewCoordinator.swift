import MapKit
import SwiftUI
import ValenciaKit

class BikeMapViewCoordinator: NSObject, MKMapViewDelegate {
  var parent: BikeMapView

  init(_ parent: BikeMapView) {
    self.parent = parent
  }

  func registerAnnotationViews(at mapView: MKMapView) {
    mapView.register(
      BikeMapParkingSpotAnnotationView.self,
      forAnnotationViewWithReuseIdentifier: MapAnnotationIdentifiers.parkingSpot.rawValue)
  }

  func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
    parent.userTrackingMode = mode
  }

  var currentSpots: [BikeParkings.Spot] = []
  var currentSpotAnnotations: [BikeMapParkingSpotAnnotation] = []
  func update(spots newSpots: [BikeParkings.Spot], of view: MKMapView) {
    guard newSpots != currentSpots else { return }

    let newSpotAnnotions = newSpots.map { BikeMapParkingSpotAnnotation($0) }

    view.removeAnnotations(currentSpotAnnotations)
    view.addAnnotations(newSpotAnnotions)

    currentSpots = newSpots
    currentSpotAnnotations = newSpotAnnotions
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? BikeMapParkingSpotAnnotation {
      let view = mapView.dequeueReusableAnnotationView(
        withIdentifier: MapAnnotationIdentifiers.parkingSpot.rawValue, for: annotation)
      view.frame.size = annotation.size
      return view
    }

    return nil
  }

  func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
    guard
      let annotation = annotation as? BikeMapParkingSpotAnnotation,
      let onTap = parent.onTap
    else { return }

    onTap(annotation.spot)
  }
}
