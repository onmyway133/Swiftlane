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
    public var xcodebuildArguments = [String]()

    public init(_ closure: (Test) -> Void = { _ in }) {
        closure(self)
    }
}

extension Test: Task {
    public var name: String { "Test" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        run(workflow: workflow, completion: completion, job: {
            xcodebuildArguments.append("test")
            try runXcodeBuild(workflow: workflow)
        })
    }
}

public extension Test {
    func destination(_ destination: Destination) {
        xcodebuildArguments.append("-destination \(destination.toString())")
    }

    func testsWithoutBuilding(enabled: Bool) {
        if enabled {
            xcodebuildArguments.append("test-without-building")
        } else {
            xcodebuildArguments.remove("test-without-building")
        }
    }
}
