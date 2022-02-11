//
//  FileSystem.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Files

public struct FileSystem {
    func moveFile(from: URL, to: URL) async throws {
        try Folder.createFolderIfNeeded(path: destination.folderPath())
        try File(path: location).move(to: Folder(path: destination.folderPath()))
        try File(path: destination).rename(to: destination.lastPathComponent(), keepExtension: false)
    }
}
