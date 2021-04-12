//
//  BootSimulator.swift
//  PumaiOS
//
//  Created by khoa on 28/12/2019.
//

import Foundation
import PumaCore

public class BootSimulator {
    public var name: String = "Boot simulator"
    public var isEnabled = true
    public var simclt = Simclt()

    private let destination: Destination

	public init(_ destination: Destination) {
		self.destination = destination
    }
}

// MARK: - Task

extension BootSimulator: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            let getDestinations = GetDestinations()
            if let udid = try getDestinations.findUdid(workflow: workflow, destination: destination) {
                simclt.arguments.append(contentsOf: [
                    "boot",
                    udid
                ])
            } else {
                throw PumaError.invalid
            }

            try simclt.run(workflow: workflow)
        }
    }
}
