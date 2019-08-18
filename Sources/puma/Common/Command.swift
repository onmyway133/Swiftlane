//
//  Command.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct Command {
    public struct Xcodebuild {
        public static let showBuildSettings = "xcodebuild -showBuildSettings"
    }
    
    public struct Instrument {
        public static let devices = "instruments -s devices"
    }
    
    public struct Agvtool {
        public static let versionNumber = "agvtool what-marketing-version"
        public static let buildNumber = "agvtool what-version"
    }
}
