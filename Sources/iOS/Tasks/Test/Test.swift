//
//  Test.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore

public class Test {
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()
    public var testsWithoutBuilding: Bool = false

    public init(_ closure: (Test) -> Void = { _ in }) {
        closure(self)
    }
}

extension Test: Task {
    public var name: String { "Test" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            if testsWithoutBuilding {
                xcodebuild.arguments.append("test-without-building")
            } else {
                xcodebuild.arguments.append("test")
            }

            try xcodebuild.run(workflow: workflow)
        }
    }
}

public extension Test {
    func configure(
        project: String,
        scheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator
    ) {
        xcodebuild.project(project)
        xcodebuild.scheme(scheme)
        xcodebuild.configuration(configuration)
        xcodebuild.sdk(sdk)
    }

    func configure(
        workspace: String,
        scheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator
    ) {
        xcodebuild.workspace(workspace)
        xcodebuild.scheme(scheme)
        xcodebuild.configuration(configuration)
        xcodebuild.sdk(sdk)
    }

    func destination(_ destination: Destination) {
        xcodebuild.destination(destination)
    }

    func testPlan(_ path: String) {
        xcodebuild.testPlan(path)
    }
}
