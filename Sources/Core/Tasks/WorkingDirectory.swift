//
//  WorkingDirectory.swift
//  PumaCore
//
//  Created by khoa on 01/12/2019.
//

import Foundation

public class WorkingDirectory: UsesCommandLine {
    public init(_ closure: (WorkingDirectory) -> Void = { _ in }) {
        closure(self)
    }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            let process = Process()
            process.launchPath = "/bin/pwd"

            try runProcess(process, workflow: workflow, processHandler: DefaultProcessHandler())
        }
    }
}

extension WorkingDirectory: Task {
    public var name: String { "Working directory" }
}
