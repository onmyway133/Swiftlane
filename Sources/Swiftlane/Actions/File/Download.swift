//
//  Download.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct Download {
    public let url: URL
    public let toFile: URL

    public init(
        url: URL,
        toFile: URL
    ) {
        self.url = url
        self.toFile = toFile
    }

    public func run() async throws {
        let (data, _) = try await URLSession.shared.data(from: url)
        try await Settings.default.fs.save(data: data, toFile: toFile)
    }
}
