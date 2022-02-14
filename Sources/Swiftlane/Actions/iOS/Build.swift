//
//  Build.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public final class Build {
    public var args = Args()
    public var buildsForTesting = false
    public var workflow: Workflow?

    public init() {}

    public func run() async throws {
        Settings.cs.action("Build")

        if buildsForTesting {
            args.flag("build")
        } else {
            args.flag("build-for-testing")
        }

        _ = try Settings.cli.run(
            program: "xcodebuild",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory,
            processHandler: XcodeBuildProcessHandler()
        )
    }
}

extension Build: UseXcodebuild {}
