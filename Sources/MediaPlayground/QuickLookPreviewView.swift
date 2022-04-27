import Foundation
import SwiftUI
import ViewHelpers

struct QuickLookPreviewView: View {
  // MARK: Lifecycle

  init(_ viewModel: MainViewModel) {
    self.viewModel = viewModel
  }

  // MARK: Internal

  @ObservedObject
  var viewModel: MainViewModel

  var body: some View {
    VStack {
      headerView
      thumbnailPreviewsView
      pickerView
    }
    .sheet(isPresented: $viewModel.showDocumentPicker) {
      SwiftUIDocumentPickerViewController($viewModel.pickedItems)
    }
    .sheet(isPresented: $viewModel.showQuickLook) {
      if let url = viewModel.itemToEdit {
        SwiftUIQLPreviewController(
          url: url,
          showCloseButton: viewModel.quickLookConfiguration.showCloseButton,
          closeButtonAction: { print("Closed was called!") },
          hideToolbar: viewModel.quickLookConfiguration.hideToolbar
        )
      }
    }
  }

  // MARK: Private

  private var headerView: some View {
    Text("Document Picker")
      .font(.headline)
  }

  private var thumbnailPreviewsView: some View {
    ScrollView {
      LazyVGrid(columns: .init(repeating: GridItem(), count: 2)) {
        ForEach(viewModel.thumbnails) { thumbnail in
          VStack(spacing: 16) {
            Spacer()
            Image(uiImage: thumbnail.image)
              .resizable()
              .scaledToFit()
              .frame(width: 120, height: 180)
            Text("Type: ") + Text(thumbnail.url.pathExtension)
            Button(action: { viewModel.editItem(url: thumbnail.url) }) {
              Text("View Item")
            }
            .padding()
          }
          .frame(width: 150, height: 300)
          .border(Color.gray)
        }
      }
    }
  }

  private var pickerView: some View {
    VStack {
      Button(action: { viewModel.pickDocuments() }) {
        Text("Click here to pick documents")
      }
      .padding()
    }
  }
}
