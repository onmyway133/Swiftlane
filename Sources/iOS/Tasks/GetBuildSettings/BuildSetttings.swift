//
//  BuildSetttings.swift
//  PumaiOS
//
//  Created by khoa on 13/12/2019.
//

import Foundation

public struct BuildSettings {
    public enum Key: String {
        case buildDirectory = "BUILT_PRODUCTS_DIR"
    }

    public let map: [String: String]

    public init(map: [String: String]) {
        self.map = map
    }

    public func value(forKey key: Key) -> String? {
        return map[key.rawValue]
    }

    public func derivedDataDirectory() -> String? {
        guard let buildDirectory = self.value(forKey: .buildDirectory) else {
            return nil
        }

        // project_name|workspace_name / Build / Products / Debug-iphonesimulator
        return URL(fileURLWithPath: buildDirectory)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .path
    }
}
