//
//  ShowAvailableDestinations.swift
//  PumaiOS
//
//  Created by khoa on 23/12/2019.
//

import Foundation
import PumaCore
import Files

public class ShowAvailableDestinations {
    public var name: String = "Show available destinations"
    public var isEnabled = true

    public init() { }
}

// MARK: - Task

extension ShowAvailableDestinations: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            let getDestinations = GetDestinations()
            let destinations = try getDestinations.getAvailable(workflow: workflow)
            destinations.forEach { destination in
                workflow.logger.text(destination.toString())
            }
        }
    }
}
