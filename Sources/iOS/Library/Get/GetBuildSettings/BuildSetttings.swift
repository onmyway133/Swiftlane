//
//  BuildSetttings.swift
//  PumaiOS
//
//  Created by khoa on 13/12/2019.
//

import Foundation
import PumaCore

public struct BuildSettings {
    public enum Key: String {
        case buildDirectory = "BUILT_PRODUCTS_DIR"
    }

    public let map: [String: String]

    public init(map: [String: String]) {
        self.map = map
    }

    public func value(forKey key: Key) throws -> String {
        return try map[key.rawValue].unwrapOrThrow(PumaError.invalid)
    }

    public func derivedDataDirectory() throws -> String {
        let buildDirectory = try self.value(forKey: .buildDirectory)

        // project_name|workspace_name / Build / Products / Debug-iphonesimulator
        return URL(fileURLWithPath: buildDirectory)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .path
    }

    public func derivedDataTestDirectory() throws -> String {
        // project_name|workspace_name / Logs / Test
        return URL(fileURLWithPath: try derivedDataDirectory())
            .appendingPathComponent("Logs", isDirectory: true)
            .appendingPathComponent("Test", isDirectory: true)
            .path
    }
}
