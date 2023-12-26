import MapKit
import SwiftUI

func LookAroundView(
  initialScene: MKLookAroundScene, showsRoadLabels: Bool, badgePosition: MKLookAroundBadgePosition
) -> some View {
  if #available(iOS 17.0, *) {
    return LookAroundPreview(
      initialScene: initialScene, showsRoadLabels: showsRoadLabels, badgePosition: badgePosition)
  } else {
    return BackportedLookAroundPreview(
      initialScene: initialScene, showsRoadLabels: showsRoadLabels, badgePosition: badgePosition)
  }
}

struct BackportedLookAroundPreview: UIViewControllerRepresentable {
  let initialScene: MKLookAroundScene
  var showsRoadLabels: Bool
  var badgePosition: MKLookAroundBadgePosition

  func makeUIViewController(context: Context) -> MKLookAroundViewController {
    MKLookAroundViewController(scene: initialScene)
  }

  func updateUIViewController(_ vc: MKLookAroundViewController, context: Context) {
    vc.showsRoadLabels = showsRoadLabels
    vc.badgePosition = badgePosition
  }
}
