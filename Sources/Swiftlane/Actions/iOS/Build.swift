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

    public init() {}

    public func run() async throws {
        if buildsForTesting {
            args.flag("build")
        } else {
            args.flag("build-for-testing")
        }

        Settings.default.cs.action("Build")
        _ = try Settings.default.cli.run(
            program: "xcodebuild",
            argument: args.toString(),
            processHandler: XcodeBuildProcessHandler()
        )
    }
}

extension Build: UseXcodebuild {}
