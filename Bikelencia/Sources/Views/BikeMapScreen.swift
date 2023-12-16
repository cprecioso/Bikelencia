//
//  ContentView.swift
//  Bikelencia
//
//  Created by Carlos Precioso on 22/5/22.
//

import CoreLocation
import MapKit
import SwiftUI
import ValenciaKit

struct BikeMapScreen: View {
  @State var isTrackingUser = true
  @ObservedObject var appModel = AppModel.shared
  @State var selectedSpot: BikeParkings.Spot? = nil

  var body: some View {
    BikeMapView(
      isTrackingUser: $isTrackingUser,
      selectedSpot: $selectedSpot
    )
    .tint(.myLocationDot)
    .ignoresSafeArea()
    .toolbar {
      BikeMapToolbarView(
        isLoading: appModel.isLoading,
        onLocationClick: {
          isTrackingUser = true
        })
    }
    .task {
      try? await appModel.updateData(userInitiated: false)
    }
    .sheet(item: $selectedSpot) { spot in
      ParkingSpotScreen(spot: spot)
        .presentationDetents([.medium, .large])
    }
  }
}
