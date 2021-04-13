//
//  Test.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore

public class Test {
    public var name: String = "Test"
    public var isEnabled = true

    private var xcodebuild = Xcodebuild()
    private let testsWithoutBuilding: Bool

    public init(withoutBuilding: Bool = false) {
        testsWithoutBuilding = withoutBuilding
    }
}

// MARK: - Modifiers

public extension Test {
    func project(_ name: String) -> Self {
        xcodebuild.projectType(.project(name))
        return self
    }

    func workspace(_ name: String) -> Self {
        xcodebuild.projectType(.workspace(name))
        return self
    }

    func scheme(_ scheme: String) -> Self {
        xcodebuild.scheme(scheme)
        return self
    }

    func configuration(_ configuration: String) -> Self {
        xcodebuild.configuration(configuration)
        return self
    }

    func sdk(_ sdk: String) -> Self {
        xcodebuild.sdk(sdk)
        return self
    }

    func destination(_ destination: Destination) -> Self {
        xcodebuild.destination(destination)
        return self
    }

    func testPlan(_ path: String) -> Self {
        xcodebuild.testPlan(path)
        return self
    }
}

// MARK: - Task

extension Test: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            if testsWithoutBuilding {
                xcodebuild.arguments.append("test-without-building")
            } else {
                xcodebuild.arguments.append("test")
            }

            try xcodebuild.run(workflow: workflow)
        }
    }
}
