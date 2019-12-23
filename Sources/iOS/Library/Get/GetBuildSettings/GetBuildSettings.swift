//
//  GetBuildSettings.swift
//  PumaiOS
//
//  Created by khoa on 13/12/2019.
//

import PumaCore

public class GetBuildSettings {
    public var xcodebuild: Xcodebuild

    public init(xcodebuild: Xcodebuild) {
        self.xcodebuild = xcodebuild
    }

    public func get(workflow: Workflow, appScheme: String) throws -> BuildSettings {
        xcodebuild.arguments.replace(containingPrefix: "-scheme", with: appScheme)
        xcodebuild.arguments.append("-showBuildSettings")
        let string = try xcodebuild.run(workflow: workflow)
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
