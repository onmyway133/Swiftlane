//
//  SetBuildNumber.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 PumaSwift. All rights reserved.
//

import Foundation
import PumaCore

public class SetBuildNumber {
    public var name: String = "Set build number"
    public var isEnabled = true
    public var agvtool = Agvtool()

    public init(_ closure: (SetBuildNumber) -> Void = { _ in }) {
        closure(self)
    }
}

extension SetBuildNumber: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            try agvtool.run(workflow: workflow)
        }
    }
}

public extension SetBuildNumber {
    func buildNumberForAllTargets(_ number: String) {
        agvtool.arguments.append(contentsOf: [
            "new-version",
            "-all",
            number
        ])
    }
}
