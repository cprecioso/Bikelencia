import SwiftUI

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

func makeListRow(
  _ label: String,
  @ViewBuilder content: () -> some View
) -> some View {
  HStack {
    Text(label)
    Spacer()
    content()
  }
}

func makeListRow(
  _ label: String,
  destination: URL,
  image: String? = nil
) -> some View {
  Link(destination: destination) {
    HStack {
      Text(label)

      if let image {
        Spacer()
        Image(systemName: image)
      }
    }
  }
}
