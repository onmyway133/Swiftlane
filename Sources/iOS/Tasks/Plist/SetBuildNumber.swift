//
//  SetBuildNumber.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 onmyway133. All rights reserved.
//

import Foundation
import PumaCore

public class SetBuildNumber: UsesAgvtool {
    public var agvtoolArguments = [String]()

    public init(_ closure: (SetBuildNumber) -> Void = { _ in }) {
        closure(self)
    }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        run(workflow: workflow, completion: completion, job: {
            try runAgvtool(workflow: workflow)
        })
    }
}

extension SetBuildNumber: Task {
    public var name: String { "Set build number" }
}

public extension SetBuildNumber {
    func buildNumberForAllTargets(_ number: String) {
        agvtoolArguments.append("new-version")
        agvtoolArguments.append("-all")
        agvtoolArguments.append(number)
    }
}
