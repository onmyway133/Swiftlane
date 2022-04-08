//
//  FileSystem.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Files
import Foundation

public struct FileSystem {
    func move(fromFile: URL, toFile: URL) async throws {
        try Folder.createFolderIfNeeded(url: toFile.folderUrl)
        try File(path: fromFile.path)
            .move(to: Folder(path: toFile.folderUrl.path))
        try File(path: toFile.path)
            .rename(to: toFile.lastPathComponent, keepExtension: false)
    }

    func save(data: Data, toFile: URL) async throws {
        try Folder.createFolderIfNeeded(url: toFile.folderUrl)
        try data.write(to: toFile)
    }

    func exists(url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
    }

    public func currentDirectory() async throws -> URL {
        let process = Process()
        process.launchPath = "/bin/pwd"

        let string = try Settings.cli.run(process: process)
        let url = URL(fileURLWithPath: string)

        return url
    }

    public var temporaryDirectory: URL {
        FileManager.default.temporaryDirectory
    }

    public var homeDirectory: URL {
        FileManager.default.homeDirectoryForCurrentUser
    }

    public var downloadsDirectory: URL {
        homeDirectory
            .appendingPathComponent("Downloads")
    }

    public var libraryDirectory: URL {
        homeDirectory
            .appendingPathComponent("Library")
    }

    public var applicationsDirectory: URL {
        URL(string: "/Applications")!
    }

    public var keychainsDirectory: URL {
        libraryDirectory
            .appendingPathComponent("Keychains")
    }

    public var provisioningProfilesDirectory: URL {
        libraryDirectory
            .appendingPathComponent("MobileDevice/Provisioning Profiles")
    }
}

extension Folder {
    static func createFolderIfNeeded(url: URL) throws {
        if !url.existsDirectory() {
            try FileManager.default.createDirectory(
                atPath: url.path,
                withIntermediateDirectories: true,
                attributes: [:]
            )
        }
    }
}

extension URL {
    func existsDirectory() -> Bool {
        var isDirectory: ObjCBool = true
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    }

    var folderUrl: URL {
        deletingLastPathComponent()
    }
}
