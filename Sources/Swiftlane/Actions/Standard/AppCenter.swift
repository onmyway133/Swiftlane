//
//  AppCenter.swift
//  Swiftlane
//
//  Created by Khoa on 17/02/2022.
//

import Foundation

public struct AppCenter {
    public struct Credential {
        let token: String

        public init(token: String) {
            self.token = token
        }
    }

    let credential: Credential

    public init(credential: Credential) {
        self.credential = credential
    }
}

public extension AppCenter {
    func upload(
        appId: String,
        ipaFile: URL,
        distributionGroup: String?
    ) async throws {
        try ensureAppCenterCLI()

        var args = Args()
        args["--token"] = credential.token
        args["-f"] = ipaFile.path
        args["-a"] = appId

        if let distributionGroup = distributionGroup {
            args["-g"] = distributionGroup
        }

        _ = try Settings.cli.run(
            program: "appcenter",
            argument: args.toString(),
            processHandler: DefaultProcessHandler()
        )
    }

    private func ensureAppCenterCLI() throws {
        guard Settings.cli.exists(program: "appcenter") else {
            Settings.cs.warn("appcenter not found")
            Settings.cs.text("Install via https://github.com/microsoft/appcenter-cli")
            throw SwiftlaneError.invalid("appcenter")
        }
    }
}
