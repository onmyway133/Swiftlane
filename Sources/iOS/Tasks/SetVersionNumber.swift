//
//  SetVersionNumber.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 onmyway133. All rights reserved.
//

import Foundation

public struct SetVersionNumber {
    public let options: Options
    
    public init(options: Options) {
        self.options = options
    }
}

public extension SetVersionNumber {
    struct Options {
        public let buildNumber: String
        
        public init(buildNumber: String) {
            self.buildNumber = buildNumber
        }
    }
}

extension SetVersionNumber: Task {
    public var name: String {
        return "Set version number"
    }
    
    public func run() throws {
        let command = "agvtool new-marketing-version \(options.buildNumber)"
        Log.command(command)
        _ = try Process().run(command: command)
    }
}
