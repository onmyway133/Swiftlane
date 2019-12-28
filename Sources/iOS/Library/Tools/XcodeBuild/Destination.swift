//
//  Destination.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct Destination: Equatable {
    public enum Kind: Equatable {
        case withId(name: String, id: String)
        case withoutId(name: String, platform: String, os: String)
    }

    public let kind: Kind
    /// If present, got from GetDestinations
    var id: String?

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
    }

    public init(
        name: String = Name.iPhoneX,
        platform: String = Platform.iOSSimulator,
        os: String
    ) {
        self.kind = .withoutId(name: name, platform: platform, os: os)
        self.id = nil
    }
    
    public init(
        name: String,
        id: String
    ) {
        self.kind = .withId(name: name, id: id)
        self.id = id
    }
}

public extension Destination {
    static let genericiOS = "generic/platform=iOS"
}

public extension Destination {
    func toString() -> String {
        var array: [String] = []

        switch kind {
        case .withId(let name, let id):
            array.append(contentsOf: [
                "name=\(name)",
                "id=\(id)"
            ])
        case .withoutId(let name, let platform, let os):
            array.append(contentsOf: [
                "name=\(name)",
                "platform=\(platform)",
                "OS=\(os)",
            ])
        }

        return array.joined(separator: ",")
    }
}
