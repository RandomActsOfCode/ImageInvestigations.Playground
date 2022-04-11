import Foundation
import MobileCoreServices
import SwiftUI
import UIKit

public struct SwiftUIImagePickerController: UIViewControllerRepresentable {
  // MARK: Lifecycle

  public init(isShown: Binding<Bool>, image: Binding<Image?>) {
    _isShown = isShown
    _image = image
  }

  // MARK: Public

  public func makeUIViewController(
    context: UIViewControllerRepresentableContext<SwiftUIImagePickerController>
  )
    -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    if let types = UIImagePickerController.availableMediaTypes(for: .camera) {
      picker.mediaTypes = types
    }
    picker.delegate = context.coordinator
    return picker
  }

  public func updateUIViewController(
    _ uiViewController: UIImagePickerController,
    context: UIViewControllerRepresentableContext<SwiftUIImagePickerController>
  ) {}

  public func makeCoordinator() -> ImagePickerCoordinator {
    Coordinator(isShown: $isShown, image: $image)
  }

  // MARK: Internal

  @Binding
  var isShown: Bool

  @Binding
  var image: Image?
}
