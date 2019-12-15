//
//  Folder+Extension.swift
//  PumaCore
//
//  Created by khoa on 15/12/2019.
//

import Foundation
import Files

public extension Folder {
    static func createFolderIfNeeded(path: String) throws {
        if !directoryExists(path: path) {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: [:])
        }
    }

    static func directoryExists(path: String) -> Bool {
        var isDirectory: ObjCBool = true
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    }
}
