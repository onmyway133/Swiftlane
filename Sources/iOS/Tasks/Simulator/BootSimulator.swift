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

    private var destination: Destination?

    public init(_ closure: (BootSimulator) -> Void = { _ in }) {
        closure(self)
    }
}

extension BootSimulator: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            let getDestinations = GetDestinations()
            if let destination = self.destination,
                let udid = try getDestinations.findUdid(workflow: workflow, destination: destination) {
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

public extension BootSimulator {
    func boot(destination: Destination) {
        self.destination = destination
    }
}
