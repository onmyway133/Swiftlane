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

	private let agvtool: Agvtool

	public init(_ buildNumber: String) {
		agvtool = Agvtool(arguments: ["new-version", "-all", buildNumber])
    }
}

// MARK: - Task

extension SetBuildNumber: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            try agvtool.run(workflow: workflow)
        }
    }
}
