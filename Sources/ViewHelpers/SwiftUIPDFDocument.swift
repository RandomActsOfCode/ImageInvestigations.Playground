import Foundation
import PDFKit
import SwiftUI

public struct SwiftUIPDFView: UIViewRepresentable {
  // MARK: Lifecycle

  public init(_ url: URL) {
    self.url = url
  }

  // MARK: Public

  public var url: URL

  public func makeUIView(context: Context) -> PDFView {
    let pdfView = PDFView()
    // Frame must be set or ScrollView errors from inside the view are generated
    pdfView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
    pdfView.document = PDFDocument(url: url)
    pdfView.autoScales = true
    pdfView.displayMode = .singlePage
    return pdfView
  }

  public func updateUIView(_ uiView: PDFView, context: Context) {
    uiView.document = PDFDocument(url: url)
  }
}
