import Foundation
import SwiftUI
import ViewHelpers

struct CameraPickerView: View {
  // MARK: Lifecycle

  init(_ viewModel: MainViewModel) {
    self.viewModel = viewModel
    self.image = nil
  }

  // MARK: Internal

  @ObservedObject
  var viewModel: MainViewModel
  @State
  var image: Image?

  var body: some View {
    VStack {
      headerView
      spacer
      imageView
      spacer
      pickerView
    }
    .sheet(isPresented: $viewModel.showCameraPicker) {
      ZStack {
        SwiftUIImagePickerController(isShown: $viewModel.showCameraPicker, image: $image)
        Circle()
          .strokeBorder().foregroundColor(Color.pink)
          .frame(width: 300, height: 300)
      }
    }
  }

  // MARK: Private

  private var headerView: some View {
    Text("Camera Picker")
      .font(.headline)
  }

  private var spacer: some View {
    Spacer()
  }

  @ViewBuilder
  private var imageView: some View {
    if let image = image {
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipShape(Circle())
        .frame(width: 300, height: 300)
    } else {
      Image(systemName: "camera")
        .resizable()
        .scaledToFit()
        .frame(width: 300, height: 300)
        .opacity(0.3)
    }
  }

  private var pickerView: some View {
    VStack {
      Button(action: { viewModel.openCamera() }) {
        Text("Click here to open camera")
      }
      .padding()
    }
  }
}
