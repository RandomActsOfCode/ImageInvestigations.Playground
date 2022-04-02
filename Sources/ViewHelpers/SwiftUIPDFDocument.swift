import Foundation
import SwiftUI
import PDFKit

public struct SwiftUIPDFView: UIViewRepresentable {
    public var url: URL

    public init(_ url: URL) {
        self.url = url
    }

    public func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.displayMode = .singlePage
        pdfView.autoScales = true
        return pdfView
    }

    public func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(url: url)
    }
}
