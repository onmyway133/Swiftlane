//
//  Altool.swift
//  PumaiOS
//
//  Created by khoa on 28/12/2019.
//

import Foundation
import PumaCore

public struct Altool {
    var arguments: [String] = []

    func run(workflow: Workflow) throws {
        try CommandLine().runBash(
            workflow: workflow,
            program: "xcrun",
            arguments: ["altool"] + arguments,
            processHandler: DefaultProcessHandler(logger: workflow.logger)
        )
    }
}
