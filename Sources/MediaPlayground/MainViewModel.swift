import Combine
import Foundation
import MediaAssets
import UIKit
import ViewHelpers

// MARK: - QuickLookConfiguration

struct QuickLookConfiguration {
  var showCloseButton = false
  var closeButtonAction: (() -> ())?
  var hideToolbar = false
}

// MARK: - MainViewModel

class MainViewModel: ObservableObject {
  // MARK: Lifecycle

  init() {
    self.showImagePicker = false
    self.showDocumentPicker = false
    self.showCameraPicker = false
    self.showQuickLook = false
    self.pickedItems = PickedItems()
    self.quickLookConfiguration = QuickLookConfiguration()
    copyAssetsToDocuments()
  }

  // MARK: Internal

  @Published
  var showImagePicker: Bool

  @Published
  var showDocumentPicker: Bool

  @Published
  var showCameraPicker: Bool

  @Published
  var showQuickLook: Bool

  @Published
  var pickedItems: PickedItems

  @Published
  var quickLookConfiguration: QuickLookConfiguration

  var itemToEdit: URL?

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

  func openCamera() {
    showCameraPicker = true
  }

  func editItem(url: URL) {
    itemToEdit = url
    showQuickLook = true
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
