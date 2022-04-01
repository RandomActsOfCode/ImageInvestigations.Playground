import SwiftUI

public struct MainView: View {
    @ObservedObject private var viewModel = MainViewModel()

    public init() {}

    public var body: some View {
        Text("Main View")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
