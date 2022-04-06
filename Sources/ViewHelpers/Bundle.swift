// https://developer.apple.com/forums/thread/664295?answerId=656407022#656407022

import Foundation

extension Foundation.Bundle {
  public static func module(forTarget targetName: String) -> Bundle {
    class CurrentBundleFinder {}

    let iOSBundleName = "MediaInvestigations_\(targetName)"
    let candidates = [
      /* Bundle should be present here when the package is linked into an App. */
      Bundle.main.resourceURL,
      /* Bundle should be present here when the package is linked into a framework. */
      Bundle(for: CurrentBundleFinder.self).resourceURL,
      /* For command-line tools. */
      Bundle.main.bundleURL,
      /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
      Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent()
        .deletingLastPathComponent().deletingLastPathComponent(),
      Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent()
        .deletingLastPathComponent(),
    ]

    for candidate in candidates {
      let iOSBundlePath = candidate?.appendingPathComponent(iOSBundleName + ".bundle")
      if let bundle = iOSBundlePath.flatMap(Bundle.init(url:)) {
        return bundle
      }
    }
    fatalError("unable to find iOS bundle \(iOSBundleName)")
  }

  public func string(forInfoDictionaryKey key: String, defaultValue: String = "") -> String {
    object(forInfoDictionaryKey: key) as? String ?? defaultValue
  }
}
