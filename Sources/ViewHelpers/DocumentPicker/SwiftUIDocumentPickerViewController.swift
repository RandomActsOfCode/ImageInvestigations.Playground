import Foundation
import QuickLook
import SwiftUI
import UIKit

// MARK: - SwiftUIDocumentPickerViewController

public struct SwiftUIDocumentPickerViewController: UIViewControllerRepresentable {
  // MARK: Lifecycle

  // MARK: - init

  public init(
    _ pickedItems: Binding<PickedItems>,
    didFinishPicking: ((Bool) -> ())? = nil
  ) {
    self.pickedItems = pickedItems
    self.didFinishPicking = didFinishPicking
  }

  // MARK: Public

  // MARK: - UIViewControllerRepresentable

  public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
    let controller = UIDocumentPickerViewController(
      forOpeningContentTypes: [.pdf],
      asCopy: false
    )
    controller.allowsMultipleSelection = true
    controller.directoryURL = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
    )[0]
    controller.delegate = context.coordinator
    return controller
  }

  public func updateUIViewController(
    _ uiViewController: UIDocumentPickerViewController,
    context: Context
  ) {
    uiViewController.allowsMultipleSelection = true
  }

  public func makeCoordinator() -> DocumentPickerCoordinator {
    DocumentPickerCoordinator(self)
  }

  // MARK: Internal

  var pickedItems: Binding<PickedItems>
  var didFinishPicking: ((_ didSelectItems: Bool) -> ())?
}
