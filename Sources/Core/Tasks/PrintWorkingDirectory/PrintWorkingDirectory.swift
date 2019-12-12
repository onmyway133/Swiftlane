//
//  WorkingDirectory.swift
//  PumaCore
//
//  Created by khoa on 01/12/2019.
//

import Foundation

public class PrintWorkingDirectory: UsesCommandLine {
    public var isEnabled = true

    public init(_ closure: (PrintWorkingDirectory) -> Void = { _ in }) {
        closure(self)
    }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            let process = Process()
            process.launchPath = "/bin/pwd"

            try runProcess(process, workflow: workflow)
        }
    }
}

extension PrintWorkingDirectory: Task {
    public var name: String { "Working directory" }
}
