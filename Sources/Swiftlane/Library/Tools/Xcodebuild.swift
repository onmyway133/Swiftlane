//
//  Xcodebuild.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public protocol UseXcodebuild: AnyObject {
    var args: Args { get set }
}

public extension UseXcodebuild {
    func project(_ name: String) {
        args["-project"] = name
            .appendingPathExtension("xcodeproj")
            .surroundingWithQuotes()
    }

    func workspace(_ name: String) {
        args["-workspace"] = name
            .appendingPathExtension("xcworkspace")
            .surroundingWithQuotes()
    }

    func scheme(_ name: String) {
        args["-scheme"] = name
            .surroundingWithQuotes()
    }

    func configuration(_ configuration: Xcodebuild.Configuration) {
        args["-configuration"] = configuration.rawValue
    }

    func sdk(_ sdk: Xcodebuild.Sdk) {
        args["-sdk"] = sdk.rawValue
    }

    func usesModernBuildSystem(_ enabled: Bool) {
        args["-UseModernBuildSystem"] = enabled.toYesNo()
    }

    func destination(_ destination: Xcodebuild.Destination) {
        args["-destination"] = destination.rawValue
            .surroundingWithQuotes()
    }

    func destination(platform: Xcodebuild.Platform, deviceName: String) {
        let map: [String: String] = [
            "name": deviceName,
            "platform": platform.rawValue
        ]
        let name = map.compactMap { key, value in
            "\(key)=\(value)"
        }.joined(separator: ",")

        args[multiple: "-destination"] = name
            .surroundingWithQuotes()
    }

    func destination(platform: Xcodebuild.Platform, deviceId: String) {
        let map: [String: String] = [
            "id": deviceId,
            "platform": platform.rawValue
        ]
        let name = map.compactMap { key, value in
            "\(key)=\(value)"
        }.joined(separator: ",")

        args[multiple: "-destination"] = name
            .surroundingWithQuotes()
    }

    func destination(platform: Xcodebuild.Platform, name: String, os: Xcodebuild.OS = .latest) {
        let map: [String: String] = [
            "name": name,
            "platform": platform.rawValue,
            "os": os.rawValue
        ]
        let name = map.compactMap { key, value in
            "\(key)=\(value)"
        }.joined(separator: ",")

        args[multiple: "-destination"] = name
            .surroundingWithQuotes()
    }

    func derivedData(_ path: String) {
        args["-derivedDataPath"] = path
    }

    func testPlan(_ path: String) {
        args["-testPlan"] = path
            .deletingPathExtension("xctestplan")
    }

    func exportPath(_ path: String) {
        args["-exportPath"] = path
            .surroundingWithQuotes()
    }

    func exportOptionsPlist(_ path: String) {
        args["-exportOptionsPlist"] = path
    }
}

public enum Xcodebuild {
    public struct Sdk {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let iPhone = Sdk(rawValue: "iphoneos")
        public static let iPhoneSimulator = Sdk(rawValue: "iphonesimulator")
    }

    public struct Configuration {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let debug = Configuration(rawValue: "DEBUG")
        public static let release = Configuration(rawValue: "RELEASE")
    }

    public struct Platform {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let iOS = Platform(rawValue: "iOS")
        public static let iOSSimulator = Platform(rawValue: "iOS Simulator")
        public static let tvOS = Platform(rawValue: "tvOS")
        public static let tvOSSimulator = Platform(rawValue: "tvOS Simulator")
        public static let watchOS = Platform(rawValue: "watchOS")
        public static let watchOSSimulator = Platform(rawValue: "watchOS Simulator")
        public static let macOS = Platform(rawValue: "OSX")
    }

    public struct Name {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let iPhone13 = Name(rawValue: "iPhone 13")
    }

    public struct OS {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let latest = OS(rawValue: "latest")
    }

    public struct Destination: Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let genericiOS = Destination(rawValue: "generic/platform=iOS")
    }
}
