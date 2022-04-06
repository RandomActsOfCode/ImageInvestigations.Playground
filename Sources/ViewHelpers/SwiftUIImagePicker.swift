import Foundation
import SwiftUI
import UIKit

public struct SwiftUIImagePickerController: UIViewControllerRepresentable {
  // MARK: Lifecycle

  public init(isShown: Binding<Bool>, image: Binding<Image?>) {
    _isShown = isShown
    _image = image
  }

  // MARK: Public

  public class Coordinator: NSObject, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
    // MARK: Lifecycle

    init(isShown: Binding<Bool>, image: Binding<Image?>) {
      _isCoordinatorShown = isShown
      _imageInCoordinator = image
    }

    // MARK: Public

    public func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      else { return }
      imageInCoordinator = Image(uiImage: unwrapImage)
      isCoordinatorShown = false
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      isCoordinatorShown = false
    }

    // MARK: Internal

    @Binding
    var isCoordinatorShown: Bool
    @Binding
    var imageInCoordinator: Image?
  }

  public func makeUIViewController(
    context: UIViewControllerRepresentableContext<SwiftUIImagePickerController>
  )
    -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.delegate = context.coordinator
    return picker
  }

  public func updateUIViewController(
    _ uiViewController: UIImagePickerController,
    context: UIViewControllerRepresentableContext<SwiftUIImagePickerController>
  ) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(isShown: $isShown, image: $image)
  }

  // MARK: Internal

  @Binding
  var isShown: Bool
  @Binding
  var image: Image?
}
