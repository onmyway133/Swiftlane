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
    func configure(
        project: String,
        scheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator,
        usesModernBuildSystem: Bool = true
    ) {
        xcodebuild.project(project)
        xcodebuild.scheme(scheme)
        xcodebuild.configuration(Configuration.debug)
        xcodebuild.sdk(Sdk.iPhoneSimulator)
        xcodebuild.usesModernBuildSystem(enabled: true)
    }

    func configure(
        workspace: String,
        scheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator,
        usesModernBuildSystem: Bool = true
    ) {
        xcodebuild.workspace(workspace)
        xcodebuild.scheme(scheme)
        xcodebuild.configuration(Configuration.debug)
        xcodebuild.sdk(Sdk.iPhoneSimulator)
        xcodebuild.usesModernBuildSystem(enabled: true)
    }

    func destination(_ destination: Destination) {
        self.xcodebuild.destination(destination)
    }

    func testPlan(_ url: URL) {
        self.xcodebuild.testPlan(url)
    }
}

public extension UsesXcodeBuild {
    @discardableResult
    func runXcodeBuild(workflow: Workflow) throws -> String {
        return try runBash(
            workflow: workflow,
            program: "xcodebuild",
            arguments: xcodebuild.arguments,
            processHandler: XcodeBuildProcessHandler()
        )
    }
}
