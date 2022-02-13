//
//  UploadASC.swift
//  Swiftlane
//
//  Created by khoa on 13/02/2022.
//

import Foundation

public final class UploadASC: UseALTool {
    public var args = Args()

    public init() {}

    public func credential(
        apiKey: String,
        apiIssuer: String
    ) {
        args["--apiKey"] = apiKey
        args["--apiIssuer"] = apiIssuer
    }
}

public extension UploadASC {
    func upload(
        ipaFile: URL
    ) async throws {
        args.flag("altool")
        args.flag("--upload-app")

        args["--file"] = ipaFile.path

        _ = try Settings.default.cli.run(
            program: "xcrun",
            argument: args.toString(),
            processHandler: DefaultProcessHandler()
        )
    }
}
