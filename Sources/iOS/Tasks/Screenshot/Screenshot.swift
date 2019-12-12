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
    public private(set) var scenarios = [Scenario]()

    public init(_ closure: (Screenshot) -> Void = { _ in }) {
        closure(self)
    }
}

extension Screenshot: Task {
    public var name: String { "Screenshot" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        Deps.console.note("Please use UITest scheme")

        with(completion) {
            guard let scenario = scenarios.last else {
                return
            }

            self.destination(scenario.destination)
            xcodebuild.arguments.append("-testLanguage \(scenario.language)")
            xcodebuild.arguments.append("-testRegion \(scenario.locale)")
            xcodebuild.arguments.append("test")

            try runXcodeBuild(workflow: workflow)
        }
    }
}

public extension Screenshot {
    func take(scenario: Scenario) {
        self.scenarios.append(scenario)
    }
}
