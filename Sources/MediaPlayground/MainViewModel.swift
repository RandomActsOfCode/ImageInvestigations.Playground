import Combine
import Foundation
import IdentifiedCollections
import MediaAssets
import QuickLookThumbnailing
import UIKit
import ViewHelpers

// MARK: - Thumbnail

struct Thumbnail: Identifiable {
  var id: UUID
  var image: UIImage
  var url: URL
}

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
    self.thumbnails = []
    self.quickLookConfiguration = QuickLookConfiguration()
    pickedItems.$items.sink {
      self.thumbnails = []
      $0.forEach { item in self.generateThumbnailRepresentations(url: item.url) }
    }.store(in: &cancellables)
    copyAssetsToDocuments()
  }

  // MARK: Internal

  var cancellables: [AnyCancellable] = []

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
  var thumbnails: [Thumbnail]

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

  private func generateThumbnailRepresentations(url: URL) {
    let size = CGSize(width: 120, height: 180)
    let scale = UIScreen.main.scale

    let request = QLThumbnailGenerator.Request(
      fileAt: url,
      size: size,
      scale: scale,
      representationTypes: .all
    )

    let generator = QLThumbnailGenerator.shared
    generator.generateRepresentations(for: request) { thumbnail, _, _ in
      DispatchQueue.main.async {
        if let thumbnail = thumbnail {
          if let index = self.thumbnails.firstIndex(where: { $0.url == url }) {
            self.thumbnails.remove(at: index)
          }
          self.thumbnails.append(.init(id: UUID(), image: thumbnail.uiImage, url: url))
        }
      }
    }
  }

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
