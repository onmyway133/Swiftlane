//
//  IncreaseBuildNumberTask.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct IncreaseBuildNumberTask {
    public init() {}
}

extension IncreaseBuildNumberTask: Task {
    public var name: String {
        return "Increase build number"
    }
    
    public func run() throws {
        let command = "agvtool next-version -all"
        Log.command(command)
        _ = try Process().run(command: command, processHandler: DefaultProcessHandler())
    }
}
