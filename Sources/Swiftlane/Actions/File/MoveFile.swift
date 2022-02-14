//
//  MoveFile.swift
//  
//
//  Created by Khoa on 11/02/2022.
//

import Foundation
import Files

public struct MoveFile {
    private let fromFile: URL
    private let toFile: URL

    public init(
        fromFile: URL,
        toFile: URL
    ) {
        self.fromFile = fromFile
        self.toFile = toFile
    }

    public func run() async throws {
        Settings.cs.action("Move file")

        try await Settings.fs.move(fromFile: fromFile, toFile: toFile)
    }
}
