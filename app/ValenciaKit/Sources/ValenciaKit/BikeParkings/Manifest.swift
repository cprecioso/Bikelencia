import Foundation
import HelperCoders
import MetaCodable

@Codable
public struct Manifest: Sendable {
  public var bikeParkings: BikeParkingsInfo

  @Codable
  public struct BikeParkingsInfo: Sendable {
    @CodedBy(LenientISO8601DateCoder())
    public var updatedAt: Date
    public var size: Int
  }
}
