import Foundation
import QuickLook
import SwiftUI
import UIKit

public struct SwiftUIDocumentPickerViewController: UIViewControllerRepresentable {
    var documentItems: Binding<PickedDocumentsItems>
    var didFinishPicking: ((_ didSelectItems: Bool) -> Void)?

    // MARK: - UIDocumentPickerDelegate

    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: SwiftUIDocumentPickerViewController

        init(_ parent: SwiftUIDocumentPickerViewController) {
            self.parent = parent
        }

        public func documentPicker(
            _ controller: UIDocumentPickerViewController,
            didPickDocumentsAt urls: [URL]
        ) {
            let dest = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var results: [URL] = []

            urls.forEach { url in
                guard url.startAccessingSecurityScopedResource() else {
                    print("can't access")
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
                        results.append(destFile)
                        url.stopAccessingSecurityScopedResource()
                    } catch {
                        print("Error copying over secure URL to Documents")
                    }
                }
            }

            DispatchQueue.main.async {
                results.forEach {
                    self.parent.documentItems.wrappedValue.append(item: .init(with: $0))
                }
            }
        }
    }

    // MARK: - init

    public init(_ documentItems: Binding<PickedDocumentsItems>, didFinishPicking: ((Bool) -> Void)? = nil) {
        self.documentItems = documentItems
        self.didFinishPicking = didFinishPicking
    }

    // MARK: - UIViewControllerRepresentable

    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: false)
        controller.allowsMultipleSelection = true
        controller.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        controller.delegate = context.coordinator
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        uiViewController.allowsMultipleSelection = true
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

public struct DocumentPickerModel: Identifiable {
    public enum DocumentType {
        case pdf
    }

    public var id: String
    public var url: URL?
    public var documentType: DocumentType = .pdf

    init(with documentURL: URL) {
        id = UUID().uuidString
        url = documentURL
    }

    mutating func delete() {
        switch documentType {
        case .pdf:
            guard let url = url else { return }
            try? FileManager.default.removeItem(at: url)
            self.url = nil
        }
    }
}

public class PickedDocumentsItems: ObservableObject {
    @Published public var items = [DocumentPickerModel]()

    public init() {}

    func append(item: DocumentPickerModel) {
        if !items.contains(where: { $0.url == item.url }) {
            items.append(item)
        }
    }

    func deleteAll() {
        for index in items.indices {
            items[index].delete()
        }

        items.removeAll()
    }
}
