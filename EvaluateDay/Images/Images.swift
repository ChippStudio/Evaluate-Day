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
internal enum Asset {
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
  internal enum Dashboards {
    internal static let dashboard0 = ImageAsset(name: "dashboard-0")
    internal static let dashboard1 = ImageAsset(name: "dashboard-1")
    internal static let dashboard10 = ImageAsset(name: "dashboard-10")
    internal static let dashboard11 = ImageAsset(name: "dashboard-11")
    internal static let dashboard12 = ImageAsset(name: "dashboard-12")
    internal static let dashboard13 = ImageAsset(name: "dashboard-13")
    internal static let dashboard14 = ImageAsset(name: "dashboard-14")
    internal static let dashboard15 = ImageAsset(name: "dashboard-15")
    internal static let dashboard16 = ImageAsset(name: "dashboard-16")
    internal static let dashboard17 = ImageAsset(name: "dashboard-17")
    internal static let dashboard18 = ImageAsset(name: "dashboard-18")
    internal static let dashboard19 = ImageAsset(name: "dashboard-19")
    internal static let dashboard2 = ImageAsset(name: "dashboard-2")
    internal static let dashboard20 = ImageAsset(name: "dashboard-20")
    internal static let dashboard21 = ImageAsset(name: "dashboard-21")
    internal static let dashboard22 = ImageAsset(name: "dashboard-22")
    internal static let dashboard23 = ImageAsset(name: "dashboard-23")
    internal static let dashboard24 = ImageAsset(name: "dashboard-24")
    internal static let dashboard25 = ImageAsset(name: "dashboard-25")
    internal static let dashboard26 = ImageAsset(name: "dashboard-26")
    internal static let dashboard27 = ImageAsset(name: "dashboard-27")
    internal static let dashboard28 = ImageAsset(name: "dashboard-28")
    internal static let dashboard29 = ImageAsset(name: "dashboard-29")
    internal static let dashboard3 = ImageAsset(name: "dashboard-3")
    internal static let dashboard30 = ImageAsset(name: "dashboard-30")
    internal static let dashboard31 = ImageAsset(name: "dashboard-31")
    internal static let dashboard32 = ImageAsset(name: "dashboard-32")
    internal static let dashboard33 = ImageAsset(name: "dashboard-33")
    internal static let dashboard34 = ImageAsset(name: "dashboard-34")
    internal static let dashboard4 = ImageAsset(name: "dashboard-4")
    internal static let dashboard5 = ImageAsset(name: "dashboard-5")
    internal static let dashboard6 = ImageAsset(name: "dashboard-6")
    internal static let dashboard7 = ImageAsset(name: "dashboard-7")
    internal static let dashboard8 = ImageAsset(name: "dashboard-8")
    internal static let dashboard9 = ImageAsset(name: "dashboard-9")
  }
  internal enum Media {
    internal static let activity = ImageAsset(name: "activity")
    internal static let close = ImageAsset(name: "close")
    internal static let collections = ImageAsset(name: "collections")
    internal static let disclosure = ImageAsset(name: "disclosure")
    internal static let down = ImageAsset(name: "down")
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
