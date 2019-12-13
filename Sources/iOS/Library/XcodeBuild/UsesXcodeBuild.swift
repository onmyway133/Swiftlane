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
        self.xcodebuild.project(project)
        self.xcodebuild.scheme(scheme)
        self.basicSettings()
    }

    func on(workspace: String, scheme: String) {
        self.xcodebuild.workspace(workspace)
        self.xcodebuild.scheme(scheme)
        self.basicSettings()
    }

    func basicSettings() {
        self.xcodebuild.configuration(Configuration.debug)
        self.xcodebuild.sdk(Sdk.iPhoneSimulator)
        self.xcodebuild.usesModernBuildSystem(enabled: true)
    }

    func configuration(_ configuration: String) {
        self.xcodebuild.configuration(configuration)
    }

    func sdk(_ sdk: String) {
        self.xcodebuild.sdk(sdk)
    }

    func usesModernBuildSystem(enabled: Bool) {
        self.xcodebuild.usesModernBuildSystem(enabled: enabled)
    }

    func destination(_ destination: Destination) {
        self.xcodebuild.destination(destination)
    }

    func testPlan(_ url: URL) {
        self.xcodebuild.testPlan(url)
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
