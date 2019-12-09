//
//  SetVersionNumber.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 onmyway133. All rights reserved.
//

import Foundation
import PumaCore

public class SetVersionNumber: UsesAgvtool {
    public var agvtoolArguments = [String]()

    public init(_ closure: (SetVersionNumber) -> Void = { _ in }) {
        closure(self)
    }
}

extension SetVersionNumber: Task {
    public var name: String { "Set version number" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        run(workflow: workflow, completion: completion, job: {
            try runAgvtool(workflow: workflow)
        })
    }
}

public extension SetVersionNumber {
    func versionNumberForAllTargets(_ number: String) {
        agvtoolArguments.append("new-marketing-version")
        agvtoolArguments.append(number)
    }
}

