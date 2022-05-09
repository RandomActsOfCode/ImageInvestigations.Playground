import Foundation
import QuickLook
import SwiftUI
import UIKit

// MARK: - ConfigurableQLPreviewController

class ConfigurableQLPreviewController: QLPreviewController {
  // MARK: Lifecycle

  init(
    showCloseButton: Bool,
    closeButtonAction: (() -> ())?,
    hideToolbar: Bool = false
  ) {
    self.showCloseButton = showCloseButton
    self.closeButtonAction = closeButtonAction
    self.hideToolbar = hideToolbar
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    self.showCloseButton = false
    self.closeButtonAction = nil
    self.hideToolbar = false
    super.init(coder: aDecoder)
  }

  // MARK: Internal

  var observations: [NSKeyValueObservation] = []
  let showCloseButton: Bool
  let closeButtonAction: (() -> ())?
  let hideToolbar: Bool
  var wasClosed: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()

    if showCloseButton {
      let closeButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(close)
      )

      navigationItem.leftBarButtonItem = closeButton
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if hideToolbar {
      navigationController?.toolbar.isHidden = true
      configureToolbarHiding()
    }
  }

  func configureToolbarHiding() {
    if let navigationToolbar = navigationController?.toolbar {
      let observation = navigationToolbar.observe(\.isHidden) { [weak self] _, _ in
        if self?.navigationController?.toolbar.isHidden == false {
          self?.navigationController?.toolbar.isHidden = true
        }
      }
      observations.append(observation)
    }
  }

  @objc
  func close() {
      wasClosed = true
    if let action = closeButtonAction {
      action()
    }

    dismiss(animated: true)
  }


}

// MARK: - SwiftUIQLPreviewController

public struct SwiftUIQLPreviewController: UIViewControllerRepresentable {
  // MARK: Lifecycle

  // MARK: - init

  public init(
    url: URL,
    showCloseButton: Bool = false,
    closeButtonAction: (() -> ())? = nil,
    hideToolbar: Bool = false,
    markUpUpdateAction: ((Bool, URL) -> ())? = nil
  ) {
    self.url = url
    self.showCloseButton = showCloseButton
    self.closeButtonAction = closeButtonAction
    self.hideToolbar = hideToolbar
    self.markUpUpdateAction = markUpUpdateAction
    self.delegate = Delegate()
  }

  // MARK: Public

  // MARK: - Coordinator

  public class Coordinator: QLPreviewControllerDataSource {
    // MARK: Lifecycle

    init(_ parent: SwiftUIQLPreviewController) {
      self.parent = parent
    }

    // MARK: Public

    public func numberOfPreviewItems(
      in controller: QLPreviewController
    )
      -> Int {
      1
    }

    public func previewController(
      _ controller: QLPreviewController, previewItemAt index: Int
    )
      -> QLPreviewItem {
      // NSURL conforms to QLPreviewItem out of the box
      parent.url as NSURL
    }

    // MARK: Internal

    let parent: SwiftUIQLPreviewController
  }

  public let url: URL

  // MARK: - UIViewControllerRepresentable

  public func makeUIViewController(context: Context) -> UINavigationController {
    let controller = ConfigurableQLPreviewController(
      showCloseButton: showCloseButton,
      closeButtonAction: closeButtonAction,
      hideToolbar: hideToolbar
    )
    controller.dataSource = context.coordinator
    controller.isEditing = true
    delegate.controller = controller
    delegate.callback = markUpUpdateAction
    controller.delegate = delegate
    let navigationController = UINavigationController(rootViewController: controller)
    return navigationController
  }

  public func updateUIViewController(
    _ uiViewController: UINavigationController,
    context: Context
  ) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  // MARK: Private

  // MARK: - QLPreviewControllerDelegate

  private class Delegate: NSObject, QLPreviewControllerDelegate {
    var controller: ConfigurableQLPreviewController!
    var callback: ((Bool, URL) -> ())?

    func previewController(
      _ controller: QLPreviewController,
      editingModeFor previewItem: QLPreviewItem
    )
    -> QLPreviewItemEditingMode {
      QLPreviewItemEditingMode.createCopy
    }

    func previewController(_ controller: QLPreviewController, didSaveEditedCopyOf previewItem: QLPreviewItem, at modifiedContentsURL: URL) {
      callback?(self.controller.wasClosed, modifiedContentsURL)
      }
  }

  // MARK: - Properties

  private var delegate: Delegate!
  private let showCloseButton: Bool
  private let closeButtonAction: (() -> ())?
  private let hideToolbar: Bool
  private let markUpUpdateAction: ((Bool, URL) -> ())?
}
