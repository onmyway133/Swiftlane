//
//  RunScript.swift
//  Colorizer
//
//  Created by khoa on 10/12/2019.
//

import Foundation

public class RunScript {
    public var name: String = "Run script"
    public var isEnabled = true

    private let script: String

    public init(_ script: String) {
        self.script = script
    }
}

// MARK: - Task

extension RunScript: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            guard !script.isEmpty else { return }
            try CommandLine().runBash(
                workflow: workflow,
                program: "",
                arguments: [script],
                processHandler: DefaultProcessHandler(logger: workflow.logger)
            )
        }
    }
}
