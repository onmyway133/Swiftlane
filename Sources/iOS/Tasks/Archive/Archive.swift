//
//  Archive.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 Puma. All rights reserved.
//

import Foundation
import PumaCore

public class Archive {
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()
    public var archivePath: String = ""

    public init(_ closure: (Archive) -> Void = { _ in }) {
        closure(self)
    }
}

extension Archive: Task {
    public var name: String { "Archive" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            xcodebuild.arguments.append("archive")
            try xcodebuild.run(workflow: workflow)
        }
    }
}

public extension Archive {
    func configure(
        project: String,
        scheme: String,
        configuration: String = Configuration.release,
        sdk: String = Sdk.iPhoneSimulator
    ) {
        xcodebuild.project(project)
        xcodebuild.scheme(scheme)
        xcodebuild.configuration(configuration)
        xcodebuild.sdk(sdk)
    }

    func configure(
        workspace: String,
        scheme: String,
        configuration: String = Configuration.release,
        sdk: String = Sdk.iPhoneSimulator
    ) {
        xcodebuild.workspace(workspace)
        xcodebuild.scheme(scheme)
        xcodebuild.configuration(configuration)
        xcodebuild.sdk(sdk)
    }
}

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
