//
//  Agvtool.swift
//  PumaiOS
//
//  Created by khoa on 10/12/2019.
//

import PumaCore

public struct Agvtool {
    var arguments: [String] = []

    func run(workflow: Workflow) throws {
        try CommandLine().runBash(
            workflow: workflow,
            program: "agvtool",
            arguments: arguments
        )
    }
}
