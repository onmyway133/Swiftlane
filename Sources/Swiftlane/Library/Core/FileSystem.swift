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
