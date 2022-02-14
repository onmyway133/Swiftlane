//
//  ExportArchive.swift
//  
//
//  Created by khoa on 13/02/2022.
//

import Foundation

public final class ExportArchive {
    public var args = Args()
    public var workflow: Workflow?

    public init() {}

    public func run() async throws {
        args.flag("-exportArchive")

        _ = try Settings.cli.run(
            program: "xcodebuild",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory,
            processHandler: XcodeBuildProcessHandler()
        )
    }

    public func exportPath(_ ipaFile: URL) {
        args["-exportPath"] = ipaFile.path
            .appendingPathExtension(".ipa")
    }

    public func exportOptionPlist(_ plistFile: URL) {
        args["-exportOptionPlist"] = plistFile.path
    }
}

extension ExportArchive: UseXcodebuild {}
