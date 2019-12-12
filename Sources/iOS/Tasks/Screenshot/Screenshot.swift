//
//  Screenshot.swift
//  PumaiOS
//
//  Created by khoa on 09/12/2019.
//

import Foundation
import PumaCore

public class Screenshot: UsesXcodeBuild {
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()
    public var saveDirectory: URL = URL(fileURLWithPath: ".")
    public private(set) var scenarios = [Scenario]()

    public init(_ closure: (Screenshot) -> Void = { _ in }) {
        closure(self)
    }
}

extension Screenshot: Task {
    public var name: String { "Screenshot" }

    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        Deps.console.note("Please use UITest scheme")

        let subTasks = scenarios.map({
            SubTask(scenario: $0, xcodebuild: xcodebuild)
        })

        Concurrent(tasks: subTasks).run(workflow: workflow, completion: completion)
    }
}

public extension Screenshot {
    func add(scenarios: [Scenario]) {
        self.scenarios.append(contentsOf: scenarios)
    }
}
