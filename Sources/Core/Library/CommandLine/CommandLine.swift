//
//  CommandLineAware.swift
//  Puma
//
//  Created by khoa on 30/11/2019.
//

import Foundation

public struct CommandLine {
    public init() {}

    @discardableResult
    public func runBash(
        workflow: Workflow,
        program: String,
        arguments: [String],
        processHandler: ProcessHandler = DefaultProcessHandler()
    ) throws -> String {
        let joinedArguments = arguments.joined(separator: " ")
        let command = "\(program) \(joinedArguments)"
        workflow.logger.highlight(command)

        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]

        return try runProcess(process, workflow: workflow, processHandler: processHandler)
    }

    @discardableResult
    public func runProcess(
        _ process: Process,
        workflow: Workflow,
        processHandler: ProcessHandler = DefaultProcessHandler()
    ) throws -> String {
        process.apply(workflow: workflow)
        return try process.run(processHandler: processHandler)
    }
}
