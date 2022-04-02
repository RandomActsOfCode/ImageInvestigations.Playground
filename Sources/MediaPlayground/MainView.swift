import SwiftUI
import ViewHelpers

public struct MainView: View {
    @ObservedObject private var viewModel = MainViewModel()

    public init() {}

    public var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: photoPickerView) {
                    Text("Image Picker (External)")
                }
                NavigationLink(destination: documentPickerView) {
                    Text("Document Picker (External)")
                }
            }
        }
    }

    private var photoPickerView: some View {
        ImagePickerView(viewModel)
    }

    private var documentPickerView: some View {
        DocumentPickerView(viewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
