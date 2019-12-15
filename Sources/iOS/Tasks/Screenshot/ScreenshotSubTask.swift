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
        public let derivedDataPath: String
        public let savePath: String

        public init(
            scenario: Scenario,
            xcodebuild: Xcodebuild,
            derivedDataPath: String,
            savePath: String)
        {
            self.name = "Screenshot language:\(scenario.language) locale:\(scenario.locale)"
            self.scenario = scenario
            self.xcodebuild = xcodebuild
            self.derivedDataPath = derivedDataPath
            self.savePath = savePath
        }
    }
}

extension Screenshot.SubTask: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        do {
            if !xcodebuild.arguments.contains(prefix: "-testPlan") {
                xcodebuild.arguments.append("-testLanguage \(scenario.language)")
                xcodebuild.arguments.append("-testRegion \(scenario.locale)")
            }

            xcodebuild.destination(scenario.destination)
            xcodebuild.arguments.append("test")
            try xcodebuild.run(workflow: workflow)
            print(derivedDataPath)
            
        } catch {
            completion(.failure(error))
        }
    }
}
