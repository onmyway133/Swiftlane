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
        Deps.console.note("Remember to set `app.launchArguments += NSProcessInfo().arguments` in your UITest")
        completion(.failure(PumaError.unknown))
    }
}

public extension Screenshot {
    func take(scenario: Scenario) {
        self.scenarios.append(scenario)
    }
}
