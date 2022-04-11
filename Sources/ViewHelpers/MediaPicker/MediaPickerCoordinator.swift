import Foundation
import PhotosUI

public class MediaPickerCoordinator: NSObject, PHPickerViewControllerDelegate {
  // MARK: Lifecycle

  init(_ parent: SwiftUIPHPickerViewController) {
    self.parent = parent
  }

  // MARK: Public

  public func picker(
    _ picker: PHPickerViewController,
    didFinishPicking results: [PHPickerResult]
  ) {
    picker.dismiss(animated: true)
    parent.didFinishPicking?(!results.isEmpty)

    guard !results.isEmpty else {
      return
    }

    for result in results {
      let itemProvider = result.itemProvider

      guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
            let utType = UTType(typeIdentifier)
      else { continue }

      if utType.conforms(to: .image) {
        addPickedItem(from: itemProvider, ofType: .photo)
      } else if utType.conforms(to: .movie) {
        addPickedItem(from: itemProvider, ofType: .video)
      }
    }
  }

  // MARK: Internal

  let parent: SwiftUIPHPickerViewController

  // MARK: Private

  private func addPickedItem(
    from itemProvider: NSItemProvider,
    ofType type: PickedItemModel.DocumentType
  ) {
    guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first else {
      return
    }

    itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
      if let error = error {
        // TODO: better error handling
        print("Error loading file representation: \(error.localizedDescription)")
        return
      }

      guard let url = url else {
        return
      }

      let documentsDirectory = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
      )[0]
      let targetURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)

      do {
        if FileManager.default.fileExists(atPath: targetURL.path) {
          try FileManager.default.removeItem(at: targetURL)
        }

        try FileManager.default.copyItem(at: url, to: targetURL)

        DispatchQueue.main.async {
          self.parent.pickedItems.wrappedValue
            .append(item: PickedItemModel(with: targetURL, ofType: type))
        }
      } catch {
        // TODO: better error handling
        print("Error copying file to app's sandbox: \(error.localizedDescription)")
      }
    }
  }
}
