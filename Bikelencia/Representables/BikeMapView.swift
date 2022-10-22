import MapKit
import SwiftUI
import ValenciaKit

struct BikeMapView: UIViewRepresentable {
  typealias UIViewType = MKMapView

  @Binding var isTrackingUser: Bool
  var userTrackingMode: MKUserTrackingMode {
    get {
      isTrackingUser ? .followWithHeading : .none
    }
    set {
      isTrackingUser = (newValue != .none)
    }
  }

  var onTap: ((BikeParkings.Spot) -> Void)? = nil

  @ObservedObject var appModel = AppModel.shared

  var mapConfiguration: MKMapConfiguration {
    let config = MKStandardMapConfiguration()
    config.elevationStyle = .realistic
    config.emphasisStyle = .muted
    config.showsTraffic = true
    config.pointOfInterestFilter = .excludingAll
    return config
  }

  func makeCoordinator() -> BikeMapViewCoordinator {
    BikeMapViewCoordinator(self)
  }

  func makeUIView(context: Context) -> MKMapView {
    let view = MKMapView()

    view.delegate = context.coordinator
    context.coordinator.registerAnnotationViews(at: view)

    view.preferredConfiguration = mapConfiguration
    view.selectableMapFeatures = []

    view.isZoomEnabled = true
    view.isPitchEnabled = true
    view.isRotateEnabled = true
    view.isScrollEnabled = true

    view.visibleMapRect = MapInitialRect

    view.showsCompass = true
    view.showsScale = true
    #if os(macOS)
      view.showsZoomControls = true
      view.showsPitchControl = false
    #endif

    view.showsUserLocation = true
    view.userTrackingMode = .followWithHeading

    return view
  }

  func updateUIView(_ view: MKMapView, context: Context) {
    if userTrackingMode != view.userTrackingMode {
      view.setUserTrackingMode(userTrackingMode, animated: true)
    }

    context.coordinator.update(spots: appModel.bikeParkings?.spots ?? [], of: view)
  }
}
