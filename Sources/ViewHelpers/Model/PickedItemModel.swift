import Foundation
import IdentifiedCollections
import Tagged

public struct PickedItemModel: Identifiable {
  // MARK: Lifecycle

  init(with url: URL, ofType type: DocumentType) {
    self.id = Id(rawValue: UUID())
    self.url = url
    self.documentType = type
  }

  // MARK: Public

  public typealias Id = Tagged<PickedItemModel, UUID> // swiftlint:disable:this type_name

  public enum DocumentType: String {
    case unknown
    case pdf
    case video
    case photo
  }

  public var id: Id
  public var url: URL
  public var documentType: DocumentType
}
