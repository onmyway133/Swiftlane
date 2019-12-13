//
//  ScreenshotSubTask.swift
//  PumaiOS
//
//  Created by khoa on 12/12/2019.
//

import Foundation
import PumaCore
import XCParseCore

public extension Screenshot {
    class SubTask {
        public let name: String
        public var isEnabled = true
        public let scenario: Scenario
        public var xcodebuild: Xcodebuild
        public let derivedDataURL: URL
        public let saveURL: URL

        public init(
            scenario: Scenario,
            xcodebuild: Xcodebuild,
            derivedDataURL: URL,
            saveURL: URL)
        {
            self.name = "Screenshot language:\(scenario.language) locale:\(scenario.locale)"
            self.scenario = scenario
            self.xcodebuild = xcodebuild
            self.derivedDataURL = derivedDataURL
            self.saveURL = saveURL
        }
    }
}

extension Screenshot.SubTask: Task, UsesXcodeBuild {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        do {
            xcodebuild.destination(scenario.destination)
            xcodebuild.arguments.append("-testLanguage \(scenario.language)")
            xcodebuild.arguments.append("-testRegion \(scenario.locale)")
            xcodebuild.arguments.append("test")
            try runXcodeBuild(workflow: workflow)


        } catch {
            completion(.failure(error))
        }
    }
}
