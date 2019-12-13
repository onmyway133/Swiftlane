//
//  ScreenshotSubTask.swift
//  PumaiOS
//
//  Created by khoa on 12/12/2019.
//

import Foundation
import PumaCore

public extension Screenshot {
    class SubTask {
        public let name: String
        public var isEnabled = true
        public let scenario: Scenario
        public var xcodebuild: Xcodebuild

        public init(scenario: Scenario, xcodebuild: Xcodebuild) {
            self.name = "Screenshot language:\(scenario.language) locale:\(scenario.locale)"
            self.scenario = scenario
            self.xcodebuild = xcodebuild
        }
    }
}

extension Screenshot.SubTask: Task, UsesXcodeBuild {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        with(completion) {
            xcodebuild.destination(scenario.destination)
            xcodebuild.arguments.append("-testLanguage \(scenario.language)")
            xcodebuild.arguments.append("-testRegion \(scenario.locale)")
            xcodebuild.arguments.append("test")

            try runXcodeBuild(workflow: workflow)
        }
    }
}
