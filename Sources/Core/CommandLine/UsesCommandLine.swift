//
//  CommandLineAware.swift
//  PumaCore
//
//  Created by khoa on 30/11/2019.
//

import Foundation

/// Any task that uses command line
public protocol UsesCommandLine: AnyObject {}

public extension UsesCommandLine {
    func runBash(
        workflow: Workflow,
        program: String,
        arguments: [String],
        processHandler: ProcessHandler = DefaultProcessHandler()
    ) throws {
        let joinedArguments = arguments.joined(separator: " ")
        let command = "\(program) \(joinedArguments)"
        Deps.console.highlight(command)

        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]

        try runProcess(process, workflow: workflow, processHandler: processHandler)
    }

    func runProcess(
        _ process: Process,
        workflow: Workflow,
        processHandler: ProcessHandler = DefaultProcessHandler()
    ) throws {
        process.apply(workflow: workflow)
        try process.run(processHandler: processHandler)
    }
}
