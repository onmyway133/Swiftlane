//
//  Simclt.swift
//  PumaCore
//
//  Created by khoa on 28/12/2019.
//

import Foundation
import PumaCore

public struct Simclt {
    var arguments: [String] = []

    func run(workflow: Workflow) throws {
        try CommandLine().runBash(
            workflow: workflow,
            program: "xcrun",
            arguments: ["simctl"] + arguments,
            processHandler: DefaultProcessHandler(logger: workflow.logger)
        )
    }
}
