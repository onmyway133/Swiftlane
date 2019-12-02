//
//  WorkingDirectory.swift
//  PumaCore
//
//  Created by khoa on 01/12/2019.
//

import Foundation

public class WorkingDirectory: UsesCommandLine {
    public var program: String { "pwd" }
    public var arguments = [String]()

    public init(_ closure: (WorkingDirectory) -> Void = { _ in }) {
        closure(self)
    }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        run(workflow: workflow, completion: completion, job: {
            let process = Process()
            process.launchPath = "/bin/\(program)"

            try run(process: process)
        })
    }
}

extension WorkingDirectory: Task {
    public var name: String { "Working directory" }
}
