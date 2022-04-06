import SwiftUI
import ViewHelpers

// MARK: - MainView

public struct MainView: View {
  // MARK: Lifecycle

  public init() {}

  // MARK: Public

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

  // MARK: Private

  @ObservedObject
  private var viewModel = MainViewModel()

  private var photoPickerView: some View {
    ImagePickerView(viewModel)
  }

  private var documentPickerView: some View {
    DocumentPickerView(viewModel)
  }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
