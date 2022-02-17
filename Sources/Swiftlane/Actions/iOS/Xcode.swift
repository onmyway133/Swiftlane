//
//  Xcode.swift
//  Swiftlane
//
//  Created by Khoa on 17/02/2022.
//

import Foundation

public struct Xcode {
    public init() {}

    public func currentPath() async throws -> String {
        var args = Args()
        args.flag("-print-path")

        return try Settings.cli.run(
            program: "xcode-select",
            argument: args.toString(),
            processHandler: DefaultProcessHandler()
        )
    }
}
