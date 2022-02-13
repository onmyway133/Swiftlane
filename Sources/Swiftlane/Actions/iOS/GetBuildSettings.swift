//
//  GetBuildSettings.swift
//  Swiftlane
//
//  Created by khoa on 13/02/2022.
//

import Foundation

public final class GetBuildSettings {
    public var workflow: Workflow?
    public var args = Args()

    public init() {}

    public func run() async throws -> BuildSettings {
        args.flag("-showBuildSettings")

        let string = try Settings.default.cli.run(
            program: "xcodebuild",
            argument: args.toString(),
            currentDirectoryURL: workflow?.directory
        )

        return parse(string: string)
    }

    // MARK: - Private

    private func parse(string: String) -> BuildSettings {
        let lines = string
            .split(separator: "\n")
            .filter({ $0.contains(" = ") })

        var map: [String: String] = [:]
        lines.forEach { line in
            let parts = line.split(separator: "=")
            if parts.count == 2 {
                let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                map[key] = value
            }
        }

        return BuildSettings(map: map)
    }
}

extension GetBuildSettings: UseXcodebuild {}

public struct BuildSettings {
    public enum Key: String {
        case buildDirectory = "BUILT_PRODUCTS_DIR"
    }

    public let map: [String: String]

    public func value(forKey key: Key) throws -> String {
        guard let value = map[key.rawValue] else {
            throw SwiftlaneError.invalid("key")
        }

        return value
    }

    public func derivedDataFolder() throws -> URL {
        let buildDirectory = try self.value(forKey: .buildDirectory)

        // project_name|workspace_name / Build / Products / Debug-iphonesimulator
        return URL(fileURLWithPath: buildDirectory)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
