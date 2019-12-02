//
//  CommandLineAware.swift
//  PumaCore
//
//  Created by khoa on 30/11/2019.
//

import Foundation

/// Any task that uses command line
public protocol UsesCommandLine: AnyObject {
    var program: String { get }
    var arguments: [String] { get set }
}

public extension UsesCommandLine {
    func runBash(workflow: Workflow, processHandler: ProcessHandler = DefaultProcessHandler()) throws {
        let joinedArguments = arguments.joined(separator: " ")
        let command = "\(program) \(joinedArguments)"
        Deps.console.command(command)

        let process = Process()
        process.apply(workflow: workflow)
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]

        try process.run(processHandler: processHandler)
    }

    func run(process: Process, workflow: Workflow, processHandler: ProcessHandler) throws {
        process.apply(workflow: workflow)
        try process.run(processHandler: processHandler)
    }
}
