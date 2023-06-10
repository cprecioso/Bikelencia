import MapKit
import SwiftUI

struct LookAround: UIViewControllerRepresentable {
  var scene: MKLookAroundScene?
  var isNavigationEnabled = true
  var pointOfInterestFilter: MKPointOfInterestFilter?
  var showsRoadLabels = true
  var badgePosition: MKLookAroundBadgePosition = .topLeading

  func makeUIViewController(context: Context) -> MKLookAroundViewController {
    MKLookAroundViewController()
  }

  func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
    if uiViewController.scene != scene {
      uiViewController.scene = scene
    }
    if uiViewController.isNavigationEnabled != isNavigationEnabled {
      uiViewController.isNavigationEnabled = isNavigationEnabled
    }
    if uiViewController.pointOfInterestFilter != pointOfInterestFilter {
      uiViewController.pointOfInterestFilter = pointOfInterestFilter
    }
    if uiViewController.showsRoadLabels != showsRoadLabels {
      uiViewController.showsRoadLabels = showsRoadLabels
    }
    if uiViewController.badgePosition != badgePosition {
      uiViewController.badgePosition = badgePosition
    }
  }
}
