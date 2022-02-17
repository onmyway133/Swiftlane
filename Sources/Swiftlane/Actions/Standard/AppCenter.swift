//
//  AppCenter.swift
//  Swiftlane
//
//  Created by Khoa on 17/02/2022.
//

import Foundation

public struct AppCenter {
    public init() {}

    public func upload(
        appId: String,
        ipaFile: URL,
        token: String,
        distributionGroup: String
    ) async throws {
        guard Settings.cli.exists(program: "appcenter") else {
            Settings.cs.warn("appcenter not found")
            Settings.cs.text("Install via https://github.com/microsoft/appcenter-cli")
            throw SwiftlaneError.invalid("appcenter")
        }

        var args = Args()
        args["-f"] = ipaFile.path
        args["-a"] = appId
        args["--token"] = token
        args["-g"] = distributionGroup

        _ = try Settings.cli.run(
            program: "appcenter",
            argument: args.toString(),
            processHandler: DefaultProcessHandler()
        )
    }
}
