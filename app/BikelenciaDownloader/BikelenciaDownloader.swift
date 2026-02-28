import BackgroundAssets
import BikelenciaCore
import Foundation

@main
final class BikelenciaDownloader: BADownloaderExtension {
  static let downloadIdentifier = "design.precioso.Bikelencia.bike-parkings"
  static let lastUpdatedAtKey = "lastKnownUpdatedAt"

  static var sharedDefaults: UserDefaults {
    UserDefaults(suiteName: BikelenciaConfig.appGroupIdentifier)!
  }

  static var cachedBikeParkingsURL: URL {
    FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: BikelenciaConfig.appGroupIdentifier
    )!.appending(path: "cached-bike-parkings.json", directoryHint: .notDirectory)
  }

  // MARK: - BADownloaderExtension

  func downloads(
    for request: BAContentRequest,
    manifestURL: URL,
    extensionInfo: BAAppExtensionInfo
  ) -> Set<BADownload> {
    guard
      let data = try? Data(contentsOf: manifestURL),
      let manifest = try? JSONDecoder().decode(Manifest.self, from: data)
    else { return [] }

    let serverTimestamp = manifest.bikeParkings.updatedAt.timeIntervalSince1970
    let lastKnown = Self.sharedDefaults.double(forKey: Self.lastUpdatedAtKey)
    if lastKnown >= serverTimestamp { return [] }

    let download = BAURLDownload(
      identifier: Self.downloadIdentifier,
      request: URLRequest(url: BikelenciaAPI.bikeParkingsURL),
      essential: false,
      fileSize: manifest.bikeParkings.size,
      applicationGroupIdentifier: BikelenciaConfig.appGroupIdentifier,
      priority: .default
    )
    return [download]
  }

  func backgroundDownload(_ download: BADownload, finishedWithFileURL fileURL: URL) {
    guard download.identifier == Self.downloadIdentifier else { return }

    do {
      let rawData = try Data(contentsOf: fileURL)
      let bikeParkings = try JSONDecoder().decode(BikeParkings.self, from: rawData)

      let encoded = try JSONEncoder().encode(bikeParkings)
      try encoded.write(to: Self.cachedBikeParkingsURL, options: .atomic)

      Self.sharedDefaults.set(
        bikeParkings.updatedAt.timeIntervalSince1970,
        forKey: Self.lastUpdatedAtKey
      )
    } catch {
      // Download processing failed; app's on-launch fetch handles recovery
    }
  }

  func backgroundDownload(_ download: BADownload, failedWithError error: Error) {
    // No-op — app's on-launch fetch is the fallback
  }
}
