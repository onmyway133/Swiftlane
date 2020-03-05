//
//  Xcodebuild.swift
//  PumaiOS
//
//  Created by khoa on 10/12/2019.
//

import PumaCore

public struct Xcodebuild {
    public var arguments: [String] = []

    @discardableResult
    func run(workflow: Workflow) throws -> String {
        return try CommandLine().runBash(
            workflow: workflow,
            program: "xcodebuild",
            arguments: arguments,
            processHandler: XcodeBuildProcessHandler()
        )
    }
}

public extension Xcodebuild {
    mutating func projectType(_ projectType: ProjectType) {
        switch projectType {
        case .project(let name):
            project(name)
        case .workspace(let name):
            workspace(name)
        }
    }

    mutating func project(_ name: String) {
        let normalizedName = name
            .appendingPathExtension("xcodeproj")
            .surroundingWithQuotes()
        arguments.append("-project \(normalizedName)")
    }

    mutating func workspace(_ name: String) {
        let normalizedName = name
            .appendingPathExtension("xcworkspace")
            .surroundingWithQuotes()

        arguments.append("-workspace \(normalizedName)")
    }

    mutating func scheme(_ name: String) {
        let normalizedName = name
            .surroundingWithQuotes()
        arguments.append("-scheme \(normalizedName)")
    }

    mutating func configuration(_ configuration: String) {
        arguments.append("-configuration \(configuration)")
    }

    mutating func sdk(_ sdk: String) {
        arguments.append("-sdk \(sdk)")
    }

    mutating func usesModernBuildSystem(enabled: Bool) {
        arguments.append("-UseModernBuildSystem=\(enabled ? "YES": "NO")")
    }

    mutating func destination(_ destination: Destination) {
        let string = destination
            .toString()
            .surroundingWithQuotes()
        arguments.append("-destination \(string)")
    }

    mutating func derivedData(_ path: String) {
        arguments.append("-derivedDataPath \(path)")
    }

    mutating func testPlan(_ path: String) {
        let path = path.deletingPathExtension("xctestplan")
        arguments.append("-testPlan \(path)")
    }

    mutating func exportPath(_ path: String) {
        let path = path.surroundingWithQuotes()
        arguments.append("-exportPath \(path)")
    }

    mutating func exportOptionsPlist(_ path: String) {
        let path = path.surroundingWithQuotes()
        arguments.append("-exportOptionsPlist \(path)")
    }
}

extension Xcodebuild {
    /// Specifies the directory where any created archives will be placed, or the archive that should be exported
    /// Require an absolute path to the .xcarchive
    mutating func archivePath(_ path: String, name: String) {
        let path = normalize(archivePath: path, name: name)
            .surroundingWithQuotes()
        arguments.append("-archivePath \(path)")
    }
}

extension Xcodebuild {
    func normalize(archivePath: String, name: String) -> String {
        return archivePath.ensuringPathExtension("xcarchive", name: name)
    }
}
