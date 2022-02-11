//
//  SetVersion.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public final class SetVersion {
    public let version: String
    public var workflow: Workflow?

    public init(version: String) {
        self.version = version
    }

    public func run() async throws {
        Settings.default.cs.action("Set version")

        try Settings.default.cli.run(
            program: "agvtool",
            argument: ["new-marketing-version", version].joined(separator: " "),
            currentDirectoryURL: workflow?.directory
        )
    }
}
