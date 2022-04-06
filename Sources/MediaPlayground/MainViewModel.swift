import Foundation
import MediaAssets
import UIKit
import ViewHelpers

class MainViewModel: ObservableObject {
  // MARK: Lifecycle

  init() {
    self.showImagePicker = false
    self.showDocumentPicker = false
    self.selectedMedia = PickedMediaItems()
    self.selectedDocuments = PickedDocumentsItems()
    copyAssetsToDocuments()
  }

  // MARK: Internal

  @Published
  var showImagePicker: Bool
  @Published
  var showDocumentPicker: Bool
  @Published
  var selectedMedia: PickedMediaItems
  @Published
  var selectedDocuments: PickedDocumentsItems

  var bundledResource: [URL] {
    Resources.all
  }

  var documentsUrl: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }

  func pickImages() {
    showImagePicker = true
  }

  func pickDocuments() {
    showDocumentPicker = true
  }

  // MARK: Private

  private func copyAssetsToDocuments() {
    Resources.all.forEach {
      let dest = documentsUrl.appendingPathComponent($0.lastPathComponent)

      do {
        if FileManager.default.fileExists(atPath: dest.path) {
          try FileManager.default.removeItem(at: dest)
        }

        try FileManager.default.copyItem(at: $0, to: dest)
      } catch {
        print("Error copy asset to Documents: \(error.localizedDescription)")
      }
    }
  }
}
