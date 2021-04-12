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

	private let agvtool = Agvtool(arguments: ["next-version", "-all"])

	public init() { }
}

// MARK: - Task

extension IncreaseBuildNumber: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            try agvtool.run(workflow: workflow)
        }
    }
}
