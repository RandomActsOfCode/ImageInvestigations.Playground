import Foundation
import UIKit

/// - Note: The core logic for UIDocumentPickerViewController is implemented in the delegate here.
public class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
  // MARK: Lifecycle

  init(_ parent: SwiftUIDocumentPickerViewController) {
    self.parent = parent
  }

  // MARK: Public

  /// - Note: All URLs are Security Scoped which requires special / guarded access
  public func documentPicker(
    _ controller: UIDocumentPickerViewController,
    didPickDocumentsAt urls: [URL]
  ) {
    let dest = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var copiedDocuments: [URL] = []

    urls.forEach { url in
      guard url.startAccessingSecurityScopedResource() else {
        // TODO: better error handling
        print("Unable to access document URL named: \(url.lastPathComponent)")
        return
      }

      var error: NSError?
      NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { url in
        let destFile = dest.appendingPathComponent(url.lastPathComponent)

        do {
          if FileManager.default.fileExists(atPath: destFile.path) {
            try FileManager.default.removeItem(at: destFile)
          }

          try FileManager.default.copyItem(at: url, to: destFile)
          copiedDocuments.append(destFile)
          url.stopAccessingSecurityScopedResource()
        } catch {
          // TODO: better error handling
          print("Error copying document URL named: \(url.lastPathComponent)")
        }
      }
    }

    DispatchQueue.main.async {
      copiedDocuments.forEach {
        self.parent.pickedItems.wrappedValue.append(item: .init(with: $0, ofType: .pdf))
      }
    }
  }

  // MARK: Internal

  let parent: SwiftUIDocumentPickerViewController
}
