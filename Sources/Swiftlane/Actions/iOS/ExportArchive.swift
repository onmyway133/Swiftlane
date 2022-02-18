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
            let plistFile = Settings.fs.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("plist")
            let builder = PlistBuilder()
            try builder.save(model: exportOptions, toFile: plistFile)
            exportOptionPlist(plistFile)
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
            .ensuringPathExtension(".ipa")
    }

    public func archivePath(_ archiveFile: URL) {
        args["-archivePath"] = archiveFile.path
            .ensuringPathExtension(".xcarchive")
    }

    public func exportOptionPlist(_ plistFile: URL) {
        args["-exportOptionPlist"] = plistFile.path
    }
}

extension ExportArchive: UseXcodebuild {}

public extension ExportArchive {
    struct ExportOptions: Encodable {
        public enum SigningStyle: String, Encodable {
            case manual = "manual"
            case automatic = "automatic"
        }

        public typealias BundleId = String
        public typealias ProfileName = String
        public typealias CertificateName = String

        public init() {}

        public var method: Xcodebuild.ExportMethod = .appStore
        public var signingStyle: SigningStyle?
        public var teamID: String?
        public var uploadSymbols: Bool?
        public var uploadBitcode: Bool?
        public var compileBitcode: Bool?
        public var signingCertificate: CertificateName?
        public var provisioningProfiles: [BundleId: ProfileName]?
    }
}
