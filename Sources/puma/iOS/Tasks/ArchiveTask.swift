//
//  Archive.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 onmyway133. All rights reserved.
//

import Foundation

public struct ArchiveTask {
    public let options: Options
    public let extend: Extend
    
    public init(options: Options, extend: Extend = Extend()) {
        self.options = options
        self.extend = extend
    }
}

extension ArchiveTask: Task {
    public var name: String {
        return "Archive"
    }
    
    public func validate() throws {
        try Validator.deviceBuildMustHaveCodeSign(options: options.buildOptions)
    }
    
    public func run() throws {
        let arguments = buildArgument(options.toArguments(), extend: extend.argument)
        let command = buildCommand("xcodebuild \(arguments) archive", extend: extend.command)
        Log.command(command)
        _ = try Process().run(command: command, processHandler: DefaultProcessHandler())
    }
}

public extension ArchiveTask {
    struct Options {
        public let buildOptions: Xcodebuild.Options
        
        /// specifies the directory where any created archives will be placed,
        /// or the archive that should be exported
        public let archivePath: String?
        
        public init(buildOptions: Xcodebuild.Options, archivePath: String? = nil) {
            self.buildOptions = buildOptions
            self.archivePath = archivePath
        }
    }
}

public extension ArchiveTask.Options {
    func toArguments() -> [String: String?] {
        return buildOptions
            .toArguments()
            .simpleMerging([
                "-archivePath ": archivePath?.surroundingWithQuotes()
            ])
    }
}
