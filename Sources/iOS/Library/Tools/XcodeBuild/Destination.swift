//
//  Destination.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct Destination: Equatable {
    public let name: String
    public let platform: String
    public let os: String
    public let udid: String?

    public struct Platform {
        public static let iOS = "iOS"
        public static let iOSSimulator = "iOS Simulator"
        public static let tvOS = "tvOS"
        public static let tvOSSimulator = "tvOS Simulator"
        public static let watchOS = "watchOS"
        public static let watchOSSimulator = "watchOS Simulator"
        public static let macOS = "OS X"
    }
    
    public struct Name {
        public static let iPhoneX = "iPhone X"
        public static let iPhoneXsMas = "iPhone Xs Max"
        public static let iPhoneXr = "iPhone Xʀ"
        public static let iPhone11 = "iPhone 11"
        public static let iPhone11Pro = "iPhone 11 Pro"
    }
    
    public struct OS {
        public static let iOS12_2 = "12.2"
        public static let iOS13_1 = "13.1"
        public static let iOS13_2_2 = "13.2.2"
        public static let iOS13_3 = "13.3"
    }

    public init(
        name: String = Name.iPhoneX,
        platform: String = Platform.iOSSimulator,
        os: String,
        udid: String? = nil
    ) {
        self.name = name
        self.platform = platform
        self.os = os
        self.udid = udid
    }
}

public extension Destination {
    static let genericiOS = "generic/platform=iOS"
}

public extension Destination {
    func toString() -> String {
        var array: [String] = []

        array.append(contentsOf: [
            "name=\(name)",
            "platform=\(platform)",
            "OS=\(os)",
        ])

        return array.joined(separator: ",")
    }
}
