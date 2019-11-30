//
//  Test.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore

public struct Test {
    public let options: Options
    
    public init(options: Options) {
        self.options = options
    }
}

extension Test: Task {
    public var name: String {
        return "Test"
    }
    
    public func validate() throws {
        try Validator.deviceBuildMustHaveCodeSign(options: options.buildOptions)
    }
    
    public func run() throws {
        let command = "xcodebuild \(toString(arguments: options.toArguments())) test"
        Log.command(command)
        _ = try Process().run(command: command)
    }
}

public extension Test {
    struct Options {
        public let buildOptions: Xcodebuild.Options
        /// use the destination described by
        /// DESTINATIONSPECIFIER (a comma-separated set of key=value pairs describing the destination to use)
        public let destination: Destination
        public let testsWithoutBuilding: Bool
        
        public init(
            buildOptions: Xcodebuild.Options,
            destination: Destination = Destination(),
            testsWithoutBuilding: Bool = true) {
            
            self.buildOptions = buildOptions
            self.destination = destination
            self.testsWithoutBuilding = testsWithoutBuilding
        }
    }
}

public extension Test.Options {
    func toArguments() -> [String?] {
        return buildOptions.toArguments() + [
            "-destination \(destination.toString())",
            testsWithoutBuilding ? "test-without-building" : nil
        ]
    }
}
