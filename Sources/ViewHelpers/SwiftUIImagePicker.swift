import Foundation
import SwiftUI
import UIKit

public struct SwiftUIImagePickerController: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: Image?

    public init(isShown: Binding<Bool>, image: Binding<Image?>) {
        _isShown = isShown
        _image = image
    }

    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isCoordinatorShown: Bool
        @Binding var imageInCoordinator: Image?

        init(isShown: Binding<Bool>, image: Binding<Image?>) {
            _isCoordinatorShown = isShown
            _imageInCoordinator = image
        }

        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            imageInCoordinator = Image(uiImage: unwrapImage)
            isCoordinatorShown = false
        }

        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isCoordinatorShown = false
        }
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<SwiftUIImagePickerController>
    ) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<SwiftUIImagePickerController>
    ) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(isShown: $isShown, image: $image)
    }
}
