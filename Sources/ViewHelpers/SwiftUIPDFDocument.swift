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
    pdfView.document = PDFDocument(url: url)
    pdfView.displayMode = .singlePage
    pdfView.autoScales = true
    return pdfView
  }

  public func updateUIView(_ uiView: PDFView, context: Context) {
    uiView.document = PDFDocument(url: url)
  }
}
