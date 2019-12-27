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
    public var script: String?

    public init(_ closure: (RunScript) -> Void = { _ in }) {
        closure(self)
    }
}

extension RunScript: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            if let script = script, !script.isEmpty {
                try CommandLine().runBash(workflow: workflow, program: "", arguments: [script])
            }
        }
    }
}
