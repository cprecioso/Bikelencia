//
//  PointOrderer.swift
//  Bikelencia
//
//  Created by Carlos Precioso on 23/5/22.
//

import Boutique
import Combine
import Foundation
import ValenciaKit

let cacheEngine = SQLiteStorageEngine.default(appendingPath: "BikeParkings")

@MainActor
class AppModel: ObservableObject {
  @Published var isLoading = false

  @AsyncStoredValue(storage: cacheEngine) var bikeParkings: BikeParkings? = nil

  var automaticURLSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .useProtocolCachePolicy
    configuration.waitsForConnectivity = true

    return URLSession(configuration: configuration)
  }()

  var userInitiatedURLSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    configuration.waitsForConnectivity = false

    return URLSession(configuration: configuration)
  }()

  static var shared: AppModel = {
    AppModel()
  }()
  private init() {}

  func updateData(userInitiated: Bool) async throws {
    isLoading = true
    defer { isLoading = false }

    // TODO Skip non-user initiated updates if the data is in the cache and low data mode is on

    let urlSession = userInitiated ? userInitiatedURLSession : automaticURLSession

    let parkings = try await BikeParkings.fetch(urlSession: urlSession)
    try await $bikeParkings.set(parkings)
  }
}
