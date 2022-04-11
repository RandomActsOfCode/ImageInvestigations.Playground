import PhotosUI
import SwiftUI

// MARK: - SwiftUIPHPickerViewController

public struct SwiftUIPHPickerViewController: UIViewControllerRepresentable {
  // MARK: Lifecycle

  public init(_ pickedItems: Binding<PickedItems>, didFinishPicking: ((Bool) -> ())? = nil) {
    self.pickedItems = pickedItems
    self.didFinishPicking = didFinishPicking
  }

  // MARK: Public

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

  public func makeCoordinator() -> MediaPickerCoordinator {
    MediaPickerCoordinator(self)
  }

  // MARK: Internal

  var pickedItems: Binding<PickedItems>
  var didFinishPicking: ((_ didSelectItems: Bool) -> ())?
}
