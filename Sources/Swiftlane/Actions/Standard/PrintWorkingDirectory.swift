//
//  PrintWorkingDirectory.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public class PrintWorkingDirectory {
    public var name: String = "Print working directory"

    public init() { }

    public func run() async throws {
        Settings.cs.action("Print working directory")

        let process = Process()
        process.launchPath = "/bin/pwd"

        try Settings.cli.run(process: process)
    }
}
