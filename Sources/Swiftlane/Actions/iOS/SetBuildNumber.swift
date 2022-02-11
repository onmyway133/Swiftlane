//
//  SetBuildNumber.swift
//  
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public final class SetBuildNumber {
    public let number: String
    public var workflow: Workflow?

    public init(number: String) {
        self.number = number
    }

    public func run() async throws {
        Settings.default.cs.action("Set build number")

        try Settings.default.cli.run(
            program: "agvtool",
            argument: ["new-version", "-all", number].joined(separator: " "),
            currentDirectoryURL: workflow?.directory
        )
    }
}
