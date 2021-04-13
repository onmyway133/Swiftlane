//
//  SetVersionNumber.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 PumaSwift. All rights reserved.
//

import Foundation
import PumaCore

public class SetVersionNumber {
    public var name: String = "Set version number"
    public var isEnabled = true

    private let agvtool: Agvtool

    public init(_ version: String) {
        agvtool = Agvtool(arguments: ["new-marketing-version", version])
    }
}

// MARK: - Task

extension SetVersionNumber: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            try agvtool.run(workflow: workflow)
        }
    }
}
