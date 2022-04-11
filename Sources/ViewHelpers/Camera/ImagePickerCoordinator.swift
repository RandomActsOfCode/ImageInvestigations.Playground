import Foundation
import SwiftUI
import UIKit

public class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate,
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
