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
    public var exportOptions: ExportOptions?

    public init() {}

    public func run() async throws {
        args.flag("-exportArchive")

        if let exportOptions = exportOptions {
            try useExportOptions(exportOptions: exportOptions)
        }

        _ = try Settings.cli.run(
            program: xcodebuild(),
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

    private func useExportOptions(exportOptions: ExportOptions) throws {
        let builder = PlistBuilder(
            dict: PlistDict(nodes: [
                PlistString(key: "teamID", value: exportOptions.teamId),
                PlistString(key: "method", value: exportOptions.method.rawValue),
                PlistBool(key: "uploadSymbols", value: exportOptions.uploadSymbols),
                PlistBool(key: "uploadBitcode", value: exportOptions.uploadBitcode)
            ])
        )

        let string = builder.toString()
        let plistFile = Settings.fs.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("plist")
        try string.write(toFile: plistFile.path, atomically: true, encoding: .utf8)
        exportOptionPlist(plistFile)
    }
}

extension ExportArchive: UseXcodebuild {}
public extension ExportArchive {
    struct ExportOptions {
        public init() {}

        public var method: Xcodebuild.ExportMethod = .appStore
        public var teamId: String = ""
        public var uploadSymbols: Bool = true
        public var uploadBitcode: Bool = true
    }
}
