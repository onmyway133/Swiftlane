//
//  File 4.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct RunScript {
    public let script: String

    public init(script: String) {
        self.script = script
    }

    func run() async throws -> String {
        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = [script]

        Settings.default.cs.highlight(script)
        return try Settings.default.cli.run(process: process)
    }
}
