//
//  IncreaseBuildNumberTask.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation
import PumaCore

public class IncreaseBuildNumber: UsesAgvtool {
    public var agvtoolArguments = [String]()

    public init(_ closure: (IncreaseBuildNumber) -> Void = { _ in }) {
        closure(self)
    }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        run(workflow: workflow, completion: completion, job: {
            try runAgvtool(workflow: workflow)
        })
    }
}

extension IncreaseBuildNumber: Task {
    public var name: String { "Increase build number" }
}

public extension IncreaseBuildNumber {
    func nextVersionForAllTargets() {
        agvtoolArguments.append("next-version")
        agvtoolArguments.append("-all")
    }
}
