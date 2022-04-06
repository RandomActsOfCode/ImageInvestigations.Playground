import Foundation

public enum Resources {
  public static var all: [URL] {
    [
      Self.sampleImageOne,
      Self.samplePdfOne,
    ]
  }

  public static var sampleImageOne: URL {
    let bundle = Bundle.mediaAssetsBundle
    guard let url = bundle.url(forResource: "broken-AC", withExtension: "jpeg") else {
      fatalError("Could not load bundle asset")
    }

    return url
  }

  public static var samplePdfOne: URL {
    let bundle = Bundle.mediaAssetsBundle
    guard let url = bundle.url(forResource: "committing-code-guidelines", withExtension: "pdf")
    else {
      fatalError("Could not load bundle asset")
    }

    return url
  }
}
