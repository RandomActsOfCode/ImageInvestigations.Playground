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
        NavigationLink(destination: devicePickerView) {
          Text("Document Picker (Device)")
        }
        NavigationLink(destination: appPickerView) {
          Text("Camera Picker")
        }
      }
    }
  }

  // MARK: Private

  @ObservedObject
  private var viewModel = MainViewModel()

  private var devicePickerView: some View {
    DevicePickerView(viewModel)
  }

  private var appPickerView: some View {
    CameraPickerView(viewModel)
  }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
