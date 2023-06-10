//
//  PointOrderer.swift
//  Bikelencia
//
//  Created by Carlos Precioso on 23/5/22.
//

import Boutique
import Combine
import ValenciaKit

let cacheEngine = SQLiteStorageEngine.default(appendingPath: "BikeParkings")

@MainActor
class AppModel: ObservableObject {
  @Published var isLoading = false

  @AsyncStoredValue(storage: cacheEngine) var bikeParkings: BikeParkings? = nil

  static var shared: AppModel = {
    AppModel()
  }()
  private init() {}

  func updateData() async throws {
    isLoading = true
    defer { isLoading = false }
    let parkings = try await BikeParkings.fetch()
    try await $bikeParkings.set(parkings)
  }
}
