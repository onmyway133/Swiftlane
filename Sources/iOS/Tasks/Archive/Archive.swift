//
//  Archive.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 onmyway133. All rights reserved.
//

import Foundation
import PumaCore

/*
public struct Archive {
    public let options: Options
    
    public init(options: Options) {
        self.options = options
    }
}

extension Archive: Task {
    public var name: String {
        return "Archive"
    }
    
    public func validate() throws {
        try Validator.deviceBuildMustHaveCodeSign(options: options.buildOptions)
    }
    
    public func run() throws {
        let command = "xcodebuild \(toString(arguments: options.toArguments())) archive"
        Log.command(command)
        _ = try Process().run(command: command)
    }
}

public extension Archive {
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

public extension Archive.Options {
    func toArguments() -> [String?] {
        return buildOptions.toArguments() + [
            archivePath.map { "-archivePath \($0.surroundingWithQuotes())" }
        ]
    }
}
*/
