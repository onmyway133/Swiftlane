//
//  UploadASC.swift
//  Swiftlane
//
//  Created by khoa on 13/02/2022.
//

import Foundation

public final class UploadASC {
    public var args = Args()

    public struct Credential {
        let apiIssuer: String
        let apiKey: String

        public init(
            apiIssuer: String,
            apiKey: String
        ) {
            self.apiKey = apiKey
            self.apiIssuer = apiIssuer
        }
    }

    let credential: Credential

    public init(
        credential: Credential
    ) {
        self.credential = credential
    }
}

public extension UploadASC {
    func upload(
        ipaFile: URL
    ) async throws {
        args.flag("altool")
        args.flag("--upload-app")
        args["--apiKey"] = credential.apiKey
        args["--apiIssuer"] = credential.apiIssuer
        args["--file"] = ipaFile.path

        _ = try Settings.default.cli.run(
            program: "xcrun",
            argument: args.toString(),
            processHandler: DefaultProcessHandler()
        )
    }
}
