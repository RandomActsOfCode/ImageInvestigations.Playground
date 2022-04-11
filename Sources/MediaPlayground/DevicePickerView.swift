import AVKit
import Foundation
import SwiftUI
import ViewHelpers

struct DevicePickerView: View {
  // MARK: Lifecycle

  init(_ viewModel: MainViewModel) {
    self.viewModel = viewModel
    self.items = viewModel.pickedItems
  }

  // MARK: Internal

  @ObservedObject
  var viewModel: MainViewModel

  @ObservedObject
  var items: PickedItems

  var body: some View {
    VStack {
      headerView
      quickLookConfigurationView
      spacer
      scrollView
      spacer
      pickersView
    }
    .sheet(isPresented: $viewModel.showDocumentPicker) {
      SwiftUIDocumentPickerViewController($viewModel.pickedItems)
    }
    .sheet(isPresented: $viewModel.showImagePicker) {
      SwiftUIPHPickerViewController($viewModel.pickedItems)
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
    Text("Document and Media Picker")
      .font(.headline)
  }

  @ViewBuilder
  private var quickLookConfigurationView: some View {
    VStack {
      Text("Quick Look Configuration")
        .font(.subheadline)
      HStack {
        Toggle("Close Button", isOn: $viewModel.quickLookConfiguration.showCloseButton)
        Toggle("Hide Toolbar", isOn: $viewModel.quickLookConfiguration.hideToolbar)
      }
      .padding()
    }
    .padding()
  }

  private var spacer: some View {
    Spacer()
  }

  private var pickersView: some View {
    VStack {
      Button(action: { viewModel.pickImages() }) {
        Text("Click here to pick media")
      }
      Button(action: { viewModel.pickDocuments() }) {
        Text("Click here to pick documents")
      }
      .padding()
    }
  }

  @ViewBuilder
  private var scrollView: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 20) {
        ForEach(items.items) { item in
          itemView(item)
            .frame(width: 250)
        }
        .padding()
        .border(Color.gray, width: 1)
      }
    }
    .border(Color.gray)
  }

  private func itemView(_ item: PickedItemModel) -> some View {
    VStack(spacing: 16) {
      Button(action: { viewModel.editItem(url: item.url) }) {
        Text("Edit Item")
      }
      .padding()

      itemThumbnailView(item)
        .frame(width: 250, height: 300)

      VStack(alignment: .leading) {
        Text("Filename:").fontWeight(.bold) + Text("\(item.url.lastPathComponent)")
        Text("File Type:").fontWeight(.bold) + Text("\(item.documentType.rawValue)")
      }
      .padding()
    }
  }

  @ViewBuilder
  private func itemThumbnailView(_ item: PickedItemModel) -> some View {
    switch item.documentType {
    case .unknown:
      Text("Unknown file type")
    case .pdf:
      SwiftUIPDFView(item.url)
    case .photo:
      if let data = try? Data(contentsOf: item.url), let uiImage = UIImage(data: data) {
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFit()
      }
    case .video:
      VideoPlayer(player: AVPlayer(url: item.url))
    }
  }
}
