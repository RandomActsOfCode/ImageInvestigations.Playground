import Foundation
import ViewHelpers

extension Bundle {
  public static var mediaAssetsBundle: Bundle = {
    Bundle.module(forTarget: "MediaAssets")
  }()
}
