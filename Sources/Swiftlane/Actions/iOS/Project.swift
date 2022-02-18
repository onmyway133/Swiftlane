//
//  Project.swift
//  Swiftlane
//
//  Created by Khoa on 18/02/2022.
//

import Foundation

public struct Project {
    public var workflow: Workflow?

    public init() {}

    public func set(
        version: String
    ) async throws {
        Settings.cs.action("Set version \(version)")

        var args = Args()
        args.flag("new-marketing-version")
        args.flag(version)


        try Settings.cli.run(
            program: "agvtool",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory
        )
    }

    public func set(
        buildNumber: String
    ) async throws {
        Settings.cs.action("Set build number \(buildNumber)")

        var args = Args()
        args.flag("new-version")
        args.flag(buildNumber)
        args.flag("-all")

        try Settings.cli.run(
            program: "agvtool",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory
        )
    }

    public func incrementBuildNumber() async throws {
        Settings.cs.action("Increment build number")

        var args = Args()
        args.flag("next-version")
        args.flag("-all")

        try Settings.cli.run(
            program: "agvtool",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory
        )
    }

    public func currentVersion() async throws -> String {
        var args = Args()
        args.flag("what-marketing-version")

        return try Settings.cli.run(
            program: "agvtool",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory
        )
    }

    public func currentBuildNumber() async throws -> String {
        var args = Args()
        args.flag("what-version")

        return try Settings.cli.run(
            program: "agvtool",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory
        )
    }
}
