//
//  Destination.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct Destination {
    public let platform: String
    public let name: String
    public let os: String?
    
    public struct Platform {
        public static let iOSSimulator = "iOS Simulator"
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
        platform: String = Platform.iOSSimulator,
        name: String = Name.iPhoneX,
        os: String? = nil) {

        self.platform = platform
        self.name = name
        self.os = os
    }
}

public extension Destination {
    func toString() -> String {
        let map: [String: String?] = [
            "platform": platform,
            "name": name,
            "OS": os
        ]
        
        return map
            .compactMap({ key, value in
                guard let value = value else {
                    return nil
                }
            
                return "\(key)=\(value)"
            })
            .joined(separator: ",")
    }
}
