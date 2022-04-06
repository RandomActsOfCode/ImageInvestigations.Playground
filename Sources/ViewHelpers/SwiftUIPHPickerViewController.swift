import PhotosUI
import SwiftUI

// MARK: - SwiftUIPHPickerViewController

public struct SwiftUIPHPickerViewController: UIViewControllerRepresentable {
  // MARK: Lifecycle

  public init(_ mediaItems: Binding<PickedMediaItems>, didFinishPicking: ((Bool) -> ())? = nil) {
    self.mediaItems = mediaItems
    self.didFinishPicking = didFinishPicking
  }

  // MARK: Public

  public class Coordinator: NSObject, PHPickerViewControllerDelegate {
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
          getPhoto(from: itemProvider)
        } else if utType.conforms(to: .movie) {
          getVideo(from: itemProvider, typeIdentifier: typeIdentifier)
        }
      }
    }

    // MARK: Internal

    let parent: SwiftUIPHPickerViewController

    // MARK: Private

    private func getPhoto(from itemProvider: NSItemProvider) {
      let objectType: NSItemProviderReading.Type = UIImage.self

      if itemProvider.canLoadObject(ofClass: objectType) {
        itemProvider.loadObject(ofClass: objectType) { object, error in
          if let error = error {
            print(error.localizedDescription)
          }

          if let image = object as? UIImage {
            DispatchQueue.main.async {
              self.parent.mediaItems.wrappedValue
                .append(item: PhotoPickerModel(with: image))
            }
          }
        }
      }
    }

    private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
      itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
        if let error = error {
          print(error.localizedDescription)
        }

        guard let url = url else { return }

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
            self.parent.mediaItems.wrappedValue
              .append(item: PhotoPickerModel(with: targetURL))
          }
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }

  public func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.selectionLimit = 0
    config.selection = .ordered
    config.preferredAssetRepresentationMode = .current
    config.filter = .any(of: [.images, .videos])
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }

  public func updateUIViewController(
    _ uiViewController: PHPickerViewController,
    context: Context
  ) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  // MARK: Internal

  var mediaItems: Binding<PickedMediaItems>
  var didFinishPicking: ((_ didSelectItems: Bool) -> ())?
}

// MARK: - PhotoPickerModel

public struct PhotoPickerModel: Identifiable {
  // MARK: Lifecycle

  init(with photo: UIImage) {
    self.id = UUID().uuidString
    self.photo = photo
    self.mediaType = .photo
  }

  init(with videoURL: URL) {
    self.id = UUID().uuidString
    self.url = videoURL
    self.mediaType = .video
  }

  // MARK: Public

  public enum MediaType {
    case photo, video
  }

  public var id: String
  public var photo: UIImage?
  public var url: URL?
  public var mediaType: MediaType = .photo

  // MARK: Internal

  mutating func delete() {
    switch mediaType {
    case .photo:
      photo = nil
    case .video:
      guard let url = url else { return }
      try? FileManager.default.removeItem(at: url)
      self.url = nil
    }
  }
}

// MARK: - PickedMediaItems

public class PickedMediaItems: ObservableObject {
  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  @Published
  public var items = [PhotoPickerModel]()

  // MARK: Internal

  func append(item: PhotoPickerModel) {
    items.append(item)
  }

  func deleteAll() {
    for index in items.indices {
      items[index].delete()
    }

    items.removeAll()
  }
}
