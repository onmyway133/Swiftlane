//
//  SetBuildNumber.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 onmyway133. All rights reserved.
//

import Foundation
import PumaCore

public struct SetBuildNumber {
    public let options: Options
    
    public init(options: Options) {
        self.options = options
    }
}

public extension SetBuildNumber {
    struct Options {
        public let buildNumber: String
        
        public init(buildNumber: String) {
            self.buildNumber = buildNumber
        }
    }
}

extension SetBuildNumber: Task {
    public var name: String {
        return "Set build number"
    }
    
    public func run() throws {
        let command = "agvtool new-version -all \(options.buildNumber)"
        Log.command(command)
        _ = try Process().run(command: command)
    }
}
