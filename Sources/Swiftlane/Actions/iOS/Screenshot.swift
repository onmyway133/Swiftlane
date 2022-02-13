//
//  Screenshot.swift
//  Swiftlane
//
//  Created by khoa on 13/02/2022.
//

import Foundation
import XCParseCore
import Files

public final class Screenshot {
    public var args = Args()
    public var workflow: Workflow?
    public var saveFolder: URL?
    public var derivedDataFolder: URL?

    public init() {}

    public func run() async throws {
        try await runUITest()
        try extractAttachments()
    }

    public func testLanguage(_ language: String) {
        args["-testLanguage"] = language
    }

    public func testRegion(_ locale: String) {
        args["-testRegion"] = locale
    }

    // MARK: - Private

    private func runUITest() async throws {
        args.flag("test")

        _ = try Settings.default.cli.run(
            program: "xcodebuild",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory,
            processHandler: XcodeBuildProcessHandler()
        )
    }

    private func extractAttachments() throws {
        let options = AttachmentExportOptions(
            addTestScreenshotsDirectory: true,
            divideByTargetModel: true,
            divideByTargetOS: true,
            divideByTestPlanConfig: true,
            divideByLanguage: true,
            divideByRegion: true,
            divideByTest: true,
            xcresulttoolCompatability: .init(),
            testSummaryFilter: { _ in true },
            activitySummaryFilter: { _ in true },
            attachmentFilter: { _ in true }
        )

        let destination = saveFolder ?? Settings.default.fs.downloadsDirectory()
        try XCPParser().extractAttachments(
            xcresultPath: xcresultPath(),
            destination: destination.path,
            options: options
        )
    }

    private func xcresultPath() throws -> String {
        guard let derivedDataFolder = derivedDataFolder else {
            throw SwiftlaneError.invalid("derivedDataFolder")
        }

        guard let scheme = args["-scheme"] else {
            throw SwiftlaneError.invalid("scheme")
        }

        let testFolder = derivedDataFolder
            .appendingPathComponent("Logs", isDirectory: true)
            .appendingPathComponent("Test", isDirectory: true)

        let folder = try Folder(path: testFolder.path).subfolders
            .filter { folder in
                folder.name.contains(".xcresult") && folder.name.contains(scheme)
            }
            .sorted(by: { f1, f2 in
                guard
                    let d1 = try f1.file(named: "Info.plist").modificationDate,
                    let d2 = try f2.file(named: "Info.plist").modificationDate
                else { return false }

                return d1 > d2
            })
            .first

        guard let folder = folder else {
            throw SwiftlaneError.invalid("folder")
        }

        return folder.path
    }
}

extension Screenshot: UseXcodebuild {}
