import Foundation
import IdentifiedCollections

public class PickedItems: ObservableObject {
  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  @Published
  public var items = IdentifiedArrayOf<PickedItemModel>()

  // MARK: Internal

  func append(item: PickedItemModel) {
    if !items.contains(where: { $0.url == item.url }) {
      items.append(item)
    }
  }

  func delete(id: PickedItemModel.Id) {
    if let index = items.firstIndex(where: { $0.id == id }) {
      delete(at: index)
    }
  }

  func delete(at index: Int) {
    if index < items.count {
      let item = items[index]
      items.remove(at: index)
      try? FileManager.default.removeItem(at: item.url)
    }
  }

  func deleteAll() {
    items.indices.forEach { delete(at: $0) }
  }
}
