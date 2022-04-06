import Foundation
import SwiftUI
import ViewHelpers
import AVKit

struct ImagePickerView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var showQuickLook = false
    @State var selectedUrl: URL?
    @State var showCamera = false
    @State var image: Image?

    init(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.selectedMedia.items) { item in
                        VStack {
                            if item.mediaType == .photo {
                                Image(uiImage: item.photo ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else if item.mediaType == .video {
                                if let url = item.url {
                                    VideoPlayer(player: AVPlayer(url: url))
                                        .frame(minWidth: 200)
                                }
                            }

                            Button(action: {
                                showQuickLook = true
                            }) {
                                Text("Edit")
                            }
                        }
                    }
                }
            }

            image?.resizable()
                .frame(width: 250, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)

            Button(action: { viewModel.pickImages() }) {
                Text("Pick Images")
            }

            Button(action: { showCamera = true }) {
                Text("Camera Time")
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            SwiftUIPHPickerViewController($viewModel.selectedMedia)
        }
        .fullScreenCover(isPresented: $showQuickLook) {
            NavigationLink(destination: Text("Full screen content")) {
                Text("Back?")
            }
        }
        .sheet(isPresented: $showCamera) {
            SwiftUIImagePickerController(isShown: $showCamera, image: $image)
        }
    }
}

extension View {
    func action(block: () -> Void) -> some View {
        block()
        return self
    }
}
