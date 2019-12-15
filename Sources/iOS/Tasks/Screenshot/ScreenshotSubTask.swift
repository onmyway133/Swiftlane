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
        public let buildSettings: BuildSettings
        public let savePath: String

        public init(
            scenario: Scenario,
            xcodebuild: Xcodebuild,
            buildSettings: BuildSettings,
            savePath: String)
        {
            self.name = "Screenshot language:\(scenario.language) locale:\(scenario.locale)"
            self.scenario = scenario
            self.xcodebuild = xcodebuild
            self.buildSettings = buildSettings
            self.savePath = savePath
        }
    }
}

extension Screenshot.SubTask: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        do {
            try build(workflow: workflow)
            try parse()
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Parse

    private func build(workflow: Workflow) throws {
        if !xcodebuild.arguments.contains(prefix: "-testPlan") {
            xcodebuild.arguments.append("-testLanguage \(scenario.language)")
            xcodebuild.arguments.append("-testRegion \(scenario.locale)")
        }
        xcodebuild.destination(scenario.destination)
        xcodebuild.arguments.append("test")
        try xcodebuild.run(workflow: workflow)
    }

    private func parse() throws {
        let testDirectory = try buildSettings.derivedDataTestDirectory()

        let options = AttachmentExportOptions(
            addTestScreenshotsDirectory: true,
            divideByTargetModel: true,
            divideByTargetOS: true,
            divideByTestPlanConfig: true,
            divideByLanguage: true,
            divideByRegion: true,
            divideByTest: true,
            xcresulttoolCompatability: .init(),
            testSummaryFilter: { _ in true },
            activitySummaryFilter: { _ in true },
            attachmentFilter: { _ in true }
        )

        let xcresultPath = "/Users/khoa/XcodeProject2/Puma/Example/DerivedData/TestPuma/Logs/Test/Test-TestAppUITests-2019.12.15_21-02-11-+0100.xcresult"

        try XCPParser().extractAttachments(
            xcresultPath: xcresultPath,
            destination: savePath,
            options: options
        )
    }
}
