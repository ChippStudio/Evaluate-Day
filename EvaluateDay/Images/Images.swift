// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Images {
  internal enum Cards {
    internal static let checkin = ImageAsset(name: "checkin")
    internal static let color = ImageAsset(name: "color")
    internal static let counter = ImageAsset(name: "counter")
    internal static let criterionHundred = ImageAsset(name: "criterionHundred")
    internal static let criterionTen = ImageAsset(name: "criterionTen")
    internal static let criterionThree = ImageAsset(name: "criterionThree")
    internal static let goal = ImageAsset(name: "goal")
    internal static let habit = ImageAsset(name: "habit")
    internal static let journal = ImageAsset(name: "journal")
    internal static let listSource = ImageAsset(name: "listSource")
    internal static let phrase = ImageAsset(name: "phrase")
    internal static let tracker = ImageAsset(name: "tracker")
  }
  internal enum Media {
    internal static let activity = ImageAsset(name: "activity")
    internal static let analytics = ImageAsset(name: "analytics")
    internal static let close = ImageAsset(name: "close")
    internal static let collections = ImageAsset(name: "collections")
    internal static let currentLocation = ImageAsset(name: "currentLocation")
    internal static let delete = ImageAsset(name: "delete")
    internal static let disclosure = ImageAsset(name: "disclosure")
    internal static let down = ImageAsset(name: "down")
    internal static let imagePlaceholder = ImageAsset(name: "imagePlaceholder")
    internal static let settings = ImageAsset(name: "settings")
    internal static let share = ImageAsset(name: "share")
    internal static let up = ImageAsset(name: "up")
  }
  internal enum Weather {
    internal static let clearDay = ImageAsset(name: "clear-day")
    internal static let clearNight = ImageAsset(name: "clear-night")
    internal static let cloudy = ImageAsset(name: "cloudy")
    internal static let fog = ImageAsset(name: "fog")
    internal static let hail = ImageAsset(name: "hail")
    internal static let partlyCloudyDay = ImageAsset(name: "partly-cloudy-day")
    internal static let partlyCloudyNight = ImageAsset(name: "partly-cloudy-night")
    internal static let rain = ImageAsset(name: "rain")
    internal static let sleet = ImageAsset(name: "sleet")
    internal static let snow = ImageAsset(name: "snow")
    internal static let thunderstorm = ImageAsset(name: "thunderstorm")
    internal static let tornado = ImageAsset(name: "tornado")
    internal static let wind = ImageAsset(name: "wind")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
