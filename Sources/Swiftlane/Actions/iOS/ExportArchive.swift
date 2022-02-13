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
    public var toFile: URL?
    public var optionFile: URL?

    public init() {}

    public func run() async throws {
        args.flag("-exportArchive")

        if let toFile = toFile {
            args["-exportPath"] = toFile.path
        }

        if let optionFile = optionFile {
            args["-exportOptionPlist"] = optionFile.path
        }

        _ = try Settings.default.cli.run(
            program: "xcodebuild",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory,
            processHandler: XcodeBuildProcessHandler()
        )
    }
}

extension ExportArchive: UseXcodebuild {}
