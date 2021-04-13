//
//  WorkingDirectory.swift
//  Puma
//
//  Created by khoa on 01/12/2019.
//

import Foundation

public class PrintWorkingDirectory {
    public var name: String = "Print working directory"
    public var isEnabled = true

    public init() { }
}

// MARK: - Task

extension PrintWorkingDirectory: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            let process = Process()
            process.launchPath = "/bin/pwd"

            try CommandLine().runProcess(
                process,
                workflow: workflow,
                processHandler: DefaultProcessHandler(logger: workflow.logger)
            )
        }
    }
}
