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
    ZStack(alignment: .top) {
      BikeMapView(
        isTrackingUser: $isTrackingUser,
        onTap: { spot in
          selectedSpot = spot
        }
      )
      .ignoresSafeArea()

      BikeMapToolbarView(
        isLoading: appModel.isLoading,
        onLocationClick: {
          isTrackingUser = true
        })
    }
    .task {
      do {
        try await appModel.updateData()
      } catch {
        print(error)
      }
    }
    .sheet(item: $selectedSpot) { spot in
      ParkingSpotScreen(spot: spot)
        .presentationDetents([.medium, .large])
    }
  }
}
