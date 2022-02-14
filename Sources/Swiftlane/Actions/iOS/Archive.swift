//
//  Archive.swift
//  
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public final class Archive {
    public var args = Args()
    public var workflow: Workflow?

    public init() {}

    public func run() async throws {
        Settings.cs.action("Archive")

        args.flag("archive")
        _ = try Settings.cli.run(
            program: "xcodebuild",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory,
            processHandler: XcodeBuildProcessHandler()
        )
    }

    public func archivePath(_ folderUrl: URL, name: String) {
        args["-archivePath"] = folderUrl
            .appendingPathComponent(name)
            .path
            .appendingPathExtension("xcarchive")
            .surroundingWithQuotes()
    }
}

extension Archive: UseXcodebuild {}
