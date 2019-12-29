//
//  IncreaseBuildNumberTask.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation
import PumaCore

public class IncreaseBuildNumber {
    public var name: String = "Increase build number"
    public var isEnabled = true
    public var agvtool = Agvtool()

    public init(_ closure: (IncreaseBuildNumber) -> Void = { _ in }) {
        closure(self)
    }
}

extension IncreaseBuildNumber: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            try agvtool.run(workflow: workflow)
        }
    }
}

public extension IncreaseBuildNumber {
    func nextVersionForAllTargets() {
        agvtool.arguments.append(contentsOf: [
            "next-version",
            "-all"
        ])
    }
}
