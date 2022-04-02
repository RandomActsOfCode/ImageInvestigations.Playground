import Foundation
import SwiftUI
import ViewHelpers
import AVKit

struct ImagePickerView: View {
    @ObservedObject var viewModel: MainViewModel

    init(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.selectedMedia.items) { item in
                        if item.mediaType == .photo {
                            Image(uiImage: item.photo ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if item.mediaType == .video {
                            if let url = item.url {
                                VideoPlayer(player: AVPlayer(url: url))
                                    .frame(minHeight: 200)
                            }
                        }
                    }
                }
            }
            .frame(height: 300)

            Button(action: { viewModel.pickImages() }) {
                Text("Pick Images")
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            SwiftUIPHPickerViewController($viewModel.selectedMedia)
        }
    }
}
