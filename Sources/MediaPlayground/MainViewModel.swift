import Foundation
import MediaAssets
import UIKit
import ViewHelpers

class MainViewModel: ObservableObject {
    @Published var showImagePicker: Bool
    @Published var selectedMedia: PickedMediaItems

    init() {
        self.showDocumentPicker = false
        self.selectedMedia = PickedMediaItems()
        copyAssetsToDocuments()
    }

    var bundledResource: [URL] {
        Resources.all
    }

    var documentsUrl: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func pickImages() {
        showImagePicker = true
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
