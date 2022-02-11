//
//  Test.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public final class Test {
    public var args = Args()
    public var testsWithoutBuilding = false
    public var workflow: Workflow?

    public init() {}

    public func run() async throws {
        if testsWithoutBuilding {
            args.flag("test-without-building")
        } else {
            args.flag("test")
        }

        Settings.default.cs.action("Test")
        _ = try Settings.default.cli.run(
            program: "xcodebuild",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory,
            processHandler: XcodeBuildProcessHandler()
        )
    }
}

extension Test: UseXcodebuild {}
