//
//  RunScript.swift
//  Colorizer
//
//  Created by khoa on 10/12/2019.
//

import Foundation

public class RunScript: UsesCommandLine {
    public var isEnabled = true
    public var script: String?

    public init(_ closure: (RunScript) -> Void = { _ in }) {
        closure(self)
    }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            if let script = script, !script.isEmpty {
                try runBash(workflow: workflow, program: "", arguments: [script])
            }
        }
    }
}

extension RunScript: Task {
    public var name: String { "Run script" }
}
