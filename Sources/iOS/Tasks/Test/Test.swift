//
//  Test.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore
import Combine

public class Test: UsesXcodeBuild {
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
            try runXcodeBuild(workflow: workflow)
        }
    }
}

public extension Test {
    func destination(_ destination: Destination) {
        xcodebuild.arguments.append("-destination \(destination.toString())")
    }

    func testsWithoutBuilding(enabled: Bool) {
        if enabled {
            xcodebuild.arguments.append("test-without-building")
        } else {
            xcodebuild.arguments.remove("test-without-building")
        }
    }
}
