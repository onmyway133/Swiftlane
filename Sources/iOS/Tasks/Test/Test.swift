//
//  Test.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore
import Combine

public class Test {
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()

    public init(_ closure: (Test) -> Void = { _ in }) {
        closure(self)
    }
}

extension Test: Task {
    public var name: String { "Test" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            xcodebuild.arguments.append("test")
            try xcodebuild.run(workflow: workflow)
        }
    }
}

public extension Test {
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
        xcodebuild.destination(destination)
    }

    func testPlan(_ path: String) {
        xcodebuild.testPlan(path)
    }

    func testsWithoutBuilding(enabled: Bool) {
        if enabled {
            xcodebuild.arguments.append("test-without-building")
        } else {
            xcodebuild.arguments.remove("test-without-building")
        }
    }
}
