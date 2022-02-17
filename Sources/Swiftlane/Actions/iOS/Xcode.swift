//
//  Xcode.swift
//  Swiftlane
//
//  Created by Khoa on 17/02/2022.
//

import Foundation

public struct Xcode {
    public init() {}

    public func currentPath() async throws -> URL {
        var args = Args()
        args.flag("-print-path")

        let string = try Settings.cli.run(
            program: "xcode-select",
            argument: args.toString(),
            processHandler: DefaultProcessHandler()
        )

        guard let url = URL(string: string) else {
            throw SwiftlaneError.invalid("url")
        }

        return url
    }
}
