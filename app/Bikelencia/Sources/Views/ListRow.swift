import SwiftUI

@MainActor
func makeListRow(
  @ViewBuilder _ label: () -> some View,
  @ViewBuilder content: () -> some View
) -> some View {
  HStack {
    label()
    Spacer()
    content()
  }
}

@MainActor
func makeListRow(
  _ label: Text,
  @ViewBuilder content: () -> some View
) -> some View {
  HStack {
    label
    Spacer()
    content()
  }
}

@MainActor
func makeListRow(
  _ label: Text,
  destination: URL,
  image: String? = nil
) -> some View {
  Link(destination: destination) {
    HStack {
      label

      if let image {
        Spacer()
        Image(systemName: image)
      }
    }
  }
}
