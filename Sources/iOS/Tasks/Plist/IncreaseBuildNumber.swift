//
//  IncreaseBuildNumberTask.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation
import PumaCore

public class IncreaseBuildNumber: UsesAgvtool {
    public var agvtool = Agvtool()

    public init(_ closure: (IncreaseBuildNumber) -> Void = { _ in }) {
        closure(self)
    }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            try runAgvtool(workflow: workflow)
        }
    }
}

extension IncreaseBuildNumber: Task {
    public var name: String { "Increase build number" }
}

public extension IncreaseBuildNumber {
    func nextVersionForAllTargets() {
        agvtool.arguments.append(contentsOf: [
            "next-version",
            "-all"
        ])
    }
}
