import Foundation
import QuickLook
import SwiftUI
import UIKit

public struct SwiftUIQLPreviewController: UIViewControllerRepresentable {
  // MARK: Lifecycle

  // MARK: - init

  public init(url: URL) {
    self.url = url
  }

  // MARK: Public

  // MARK: - Coordinator

  public class Coordinator: QLPreviewControllerDataSource {
    // MARK: Lifecycle

    init(_ parent: SwiftUIQLPreviewController) {
      self.parent = parent
    }

    // MARK: Public

    public func numberOfPreviewItems(
      in controller: QLPreviewController
    )
      -> Int {
      1
    }

    public func previewController(
      _ controller: QLPreviewController, previewItemAt index: Int
    )
      -> QLPreviewItem {
      // NSURL conforms to QLPreviewItem out of the box
      parent.url as NSURL
    }

    // MARK: Internal

    let parent: SwiftUIQLPreviewController
  }

  public let url: URL

  // MARK: - UIViewControllerRepresentable

  public func makeUIViewController(context: Context) -> UINavigationController {
    let controller = QLPreviewController()
    controller.dataSource = context.coordinator
    controller.isEditing = true
    controller.delegate = delegate
    let navigationController = UINavigationController(rootViewController: controller)
    return navigationController
  }

  public func updateUIViewController(
    _ uiViewController: UINavigationController,
    context: Context
  ) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  // MARK: Private

  // MARK: - QLPreviewControllerDelegate

  private class Delegate: NSObject, QLPreviewControllerDelegate {
    func previewController(
      _ controller: QLPreviewController,
      editingModeFor previewItem: QLPreviewItem
    )
      -> QLPreviewItemEditingMode {
      QLPreviewItemEditingMode.updateContents
    }
  }

  // MARK: - Properties

  private let delegate = Delegate()
}
