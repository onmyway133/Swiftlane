//
//  MoveFile.swift
//  PumaCore
//
//  Created by khoa on 29/12/2019.
//

import Foundation
import Files

public class MoveFile {
    public var name: String = "Move file"
    public var isEnabled = true
    public var script: String?

    private var from: String?
    private var to: String?

    public init(_ closure: (MoveFile) -> Void = { _ in }) {
        closure(self)
    }
}

extension MoveFile: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        guard let from = from, let to = to else {
            completion(.failure(PumaError.invalid))
            return
        }

        do {
            try Folder.createFolderIfNeeded(path: to.folderPath())
            try File(path: from).move(to: Folder(path: to.folderPath()))
            try File(path: to).rename(to: to.lastPathComponent(), keepExtension: false)
        } catch {
            completion(.failure(error))
        }
    }
}

public extension MoveFile {
    /// Move file to another location
    /// - Parameters:
    ///   - fromPath: Full path to source location. For example /Users/me/Downloads/abc.md
    ///   - toPath: Full path to destination location. For example /Users/me/Downloads/def.md
    func move(from: String, to: String) {
        self.from = from
        self.to = from
    }
}
