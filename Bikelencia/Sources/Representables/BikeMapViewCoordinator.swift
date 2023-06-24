import MapKit
import SwiftUI
import ValenciaKit

class BikeMapViewCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
  var parent: BikeMapView
  let manager = CLLocationManager()

  init(_ parent: BikeMapView) {
    self.parent = parent

    super.init()

    self.manager.delegate = self
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .authorizedAlways
      || manager.authorizationStatus == .authorizedWhenInUse
    {
      parent.isTrackingUser = true
    }
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

  func annotation(for spot: BikeParkings.Spot) -> BikeMapParkingSpotAnnotation? {
    currentSpotAnnotations.first(where: { $0.spot == spot })
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

  func spot(from annotation: MKAnnotation) -> BikeParkings.Spot? {
    (annotation as? BikeMapParkingSpotAnnotation)?.spot
  }

  func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
    guard let spot = spot(from: annotation) else { return }
    parent.selectedSpot = spot
  }

  func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
    parent.selectedSpot = nil
  }
}
