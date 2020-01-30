//
//  Destination.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct Destination: Equatable {
    public let name: String
    public let platform: Platform
    public let os: String
    public let udid: String?

    public enum Platform: String {
        case iOS = "iOS"
        case iOSSimulator = "iOS Simulator"
        case tvOS = "tvOS"
        case tvOSSimulator = "tvOS Simulator"
        case watchOS = "watchOS"
        case watchOSSimulator = "watchOS Simulator"
        case macOS = "OS X"
        
        static var allSupported: [Self] {
            return [
                .iOS,
                .watchOS,
                .macOS,
                .tvOS,
            ]
        }
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
        platform: Platform = .iOSSimulator,
        os: String,
        udid: String? = nil
    ) { 
        self.name = name
        self.platform = platform
        self.os = os
        self.udid = udid
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
               lhs.platform == rhs.platform &&
               lhs.os == rhs.os
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
