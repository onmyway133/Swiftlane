//
//  XcodeBuildAware.swift
//  PumaiOS
//
//  Created by khoa on 30/11/2019.
//

import Foundation
import PumaCore

/// Any task that uses xcodebuild
public protocol UsesXcodeBuild: UsesCommandLine {
    var xcodebuild: Xcodebuild { get set }
}

public extension UsesXcodeBuild {
    func on(project: String, scheme: String) {
        self.project(project)
        self.scheme(scheme)
        self.basicSettings()
    }

    func on(workspace: String, scheme: String) {
        self.workspace(workspace)
        self.scheme(scheme)
        self.basicSettings()
    }

    func basicSettings() {
        self.configuration(Configuration.debug)
        self.sdk(Sdk.iPhoneSimulator)
        self.usesModernBuildSystem(enabled: true)
    }

    func project(_ name: String) {
        let normalizedName = name
            .addingFileExtension("xcodeproj")
            .surroundingWithQuotes()
        xcodebuild.arguments.append("-project \(normalizedName)")
    }

    func workspace(_ name: String) {
        let normalizedName = name
            .addingFileExtension("xcworkspace")
            .surroundingWithQuotes()

        xcodebuild.arguments.append("-workspace \(normalizedName)")
    }

    func scheme(_ name: String) {
        let normalizedName = name
            .surroundingWithQuotes()
        xcodebuild.arguments.append("-scheme \(normalizedName)")
    }

    func configuration(_ configuration: String) {
        xcodebuild.arguments.append("-configuration \(configuration)")
    }

    func sdk(_ sdk: String) {
        xcodebuild.arguments.append("-sdk \(sdk)")
    }

    func usesModernBuildSystem(enabled: Bool) {
        xcodebuild.arguments.append("-UseModernBuildSystem=\(enabled ? "YES": "NO")")
    }

    func destination(_ destination: Destination) {
        let string = destination
            .toString()
            .surroundingWithQuotes()
        xcodebuild.arguments.append("-destination \(string)")
    }

    func derivedDataPath(_ url: URL) {
        xcodebuild.arguments.append("-derivedDataPath \(url.path)")
    }

    func testPlan(_ url: URL) {
        let path = url.path.removingFileExtension("xctestplan")
        xcodebuild.arguments.append("-testplan \(path)")
    }
}

public extension UsesXcodeBuild {
    func runXcodeBuild(workflow: Workflow) throws {
        try runBash(
            workflow: workflow,
            program: "xcodebuild",
            arguments: xcodebuild.arguments,
            processHandler: XcodeBuildProcessHandler()
        )
    }
}
