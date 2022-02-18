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
        let dict = PlistDict {
            PlistBool(key: "uploadSymbols", value: exportOptions.uploadSymbols)
            PlistBool(key: "uploadBitcode", value: exportOptions.uploadBitcode)
            PlistBool(key: "compileBitcode", value: exportOptions.compileBitcode)
            PlistString(key: "signingStyle", value: exportOptions.signingStyle.rawValue)

            if let teamId = exportOptions.teamId {
                PlistString(key: "teamID", value: teamId)
            }

            if let signingCertificate = exportOptions.signingCertificate {
                PlistString(key: "signingCertificate", value: signingCertificate)
            }

            if let profiles = exportOptions.provisioningProfiles {
                PlistDict(key: "provisioningProfiles") {
                    for profile in profiles {
                        PlistString(key: profile.bundleId, value: profile.profileName)
                    }
                }
            }
        }

        let string = dict.toPlistString()
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
        public enum SigningStyle: String {
            case manual = "manual"
            case automatic = "automatic"
        }

        public struct ProvisioningProfile {
            let bundleId: String
            let profileName: String

            public init(
                bundleId: String,
                profileName: String
            ) {
                self.bundleId = bundleId
                self.profileName = profileName
            }
        }

        public init() {}

        public var method: Xcodebuild.ExportMethod = .appStore
        public var signingStyle: SigningStyle = .automatic
        public var teamId: String?
        public var uploadSymbols: Bool = true
        public var uploadBitcode: Bool = true
        public var compileBitcode: Bool = true
        public var signingCertificate: String?
        public var provisioningProfiles: [ProvisioningProfile]?
    }
}
