//
//  Test.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public struct TestTask {
    public let options: Options
    public let extend: Extend
    
    public init(options: Options, extend: Extend = Extend()) {
        self.options = options
        self.extend = extend
    }
}

extension TestTask: Task {
    public var name: String {
        return "Test"
    }
    
    public func validate() throws {
        try Validator.deviceBuildMustHaveCodeSign(options: options.buildOptions)
    }
    
    public func run() throws {
        let arguments = buildArgument(options.toArguments(), extend: extend.argument)
        let command = buildCommand("xcodebuild \(arguments) test", extend: extend.command)
        Log.command(command)
        _ = try Process().run(command: command, processHandler: DefaultProcessHandler())
    }
}

public extension TestTask {
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

public extension TestTask.Options {
    func toArguments() -> [String: String?] {
        return buildOptions
            .toArguments()
            .simpleMerging([
                "-destination ": "'\(destination.toString())'",
                "test-without-building": testsWithoutBuilding ? "" : nil
            ])
    }
}
