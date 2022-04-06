import AVKit
import Foundation
import SwiftUI
import ViewHelpers

struct DocumentPickerView: View {
  // MARK: Lifecycle

  init(_ viewModel: MainViewModel) {
    self.viewModel = viewModel
    self.foo = viewModel.selectedDocuments
  }

  // MARK: Internal

  @ObservedObject
  var viewModel: MainViewModel
  @ObservedObject
  var foo: PickedDocumentsItems

  var body: some View {
    VStack {
      ScrollView(.horizontal) {
        LazyHStack {
          ForEach(foo.items) { item in
            SwiftUIPDFView(item.url!) // swiftlint:disable:this force_unwrapping
              .frame(width: 300)
          }
        }
      }

      Button(action: { viewModel.pickDocuments() }) {
        Text("Pick Documents")
      }
    }
    .sheet(isPresented: $viewModel.showDocumentPicker) {
      SwiftUIDocumentPickerViewController($viewModel.selectedDocuments)
    }
  }
}
