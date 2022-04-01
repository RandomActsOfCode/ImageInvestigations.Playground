import Foundation
import MediaAssets

class MainViewModel: ObservableObject {
    init() {
        copyAssetsToDocuments()
    }

    var bundledResource: [URL] {
        Resources.all
    }

    var documentsUrl: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
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

extension URL {
    var filename: String {
        let ext = self.lastPathComponent
        let name = self.deletingLastPathComponent().lastPathComponent
        return "\(name).\(ext)"
    }
}
