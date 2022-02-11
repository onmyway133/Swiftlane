//
//  MoveFile.swift
//  
//
//  Created by Khoa on 11/02/2022.
//

import Foundation
import Files

public struct MoveFile {
    public init() {}

    public func move(from: URL, to: URL) async throws {

    }
}

public class MoveFile {
    public var name: String = "Move file"
    public var isEnabled = true

    private let location: String
    private let destination: String

    public init(from location: String, to destination: String) {
        self.location = location
        self.destination = destination
    }
}

extension MoveFile: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        do {
            try Folder.createFolderIfNeeded(path: destination.folderPath())
            try File(path: location).move(to: Folder(path: destination.folderPath()))
            try File(path: destination).rename(to: destination.lastPathComponent(), keepExtension: false)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

