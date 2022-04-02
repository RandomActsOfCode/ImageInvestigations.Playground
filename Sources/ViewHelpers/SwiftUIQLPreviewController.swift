import Foundation
import QuickLook
import SwiftUI
import UIKit

public struct SwiftUIQLPreviewController: UIViewControllerRepresentable {
    // MARK: - QLPreviewControllerDelegate

    private class Delegate: NSObject, QLPreviewControllerDelegate {
        func previewController(
            _ controller: QLPreviewController,
            editingModeFor previewItem: QLPreviewItem
        ) -> QLPreviewItemEditingMode {
            QLPreviewItemEditingMode.updateContents
        }
    }

    // MARK: - Coordinator

    public class Coordinator: QLPreviewControllerDataSource {
        let parent: SwiftUIQLPreviewController

        init(_ parent: SwiftUIQLPreviewController) {
            self.parent = parent
        }

        public func numberOfPreviewItems(
            in controller: QLPreviewController
        ) -> Int {
            1
        }

        public func previewController(
            _ controller: QLPreviewController, previewItemAt index: Int
        ) -> QLPreviewItem {
            // NSURL conforms to QLPreviewItem out of the box
            return parent.url as NSURL
        }
    }

    // MARK: - Properties

    private let delegate = Delegate()
    public let url: URL

    // MARK: - init

    public init(url: URL) {
        self.url = url
    }

    // MARK: - UIViewControllerRepresentable

    public func makeUIViewController(context: Context) -> UINavigationController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        controller.isEditing = true
        controller.delegate = self.delegate
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }

    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
