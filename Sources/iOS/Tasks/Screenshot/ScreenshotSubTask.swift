//
//  ScreenshotSubTask.swift
//  PumaiOS
//
//  Created by khoa on 12/12/2019.
//

import Foundation
import PumaCore
import XCParseCore
import Files

public extension Screenshot {
    class SubTask {
        public let name: String
        public var isEnabled = true
        public let scenario: Scenario
        public let buildSettings: BuildSettings
        public let task: Screenshot

        public init(
            scenario: Scenario,
            task: Screenshot,
            buildSettings: BuildSettings
        ) {
            self.name = "Screenshot language:\(scenario.language) locale:\(scenario.locale)"
            self.scenario = scenario
            self.task = task
            self.buildSettings = buildSettings
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
        var xcodebuild = task.xcodebuild

        if !xcodebuild.arguments.contains(prefix: "-testPlan") {
            xcodebuild.arguments.append("-testLanguage \(scenario.language)")
            xcodebuild.arguments.append("-testRegion \(scenario.locale)")
        }
        xcodebuild.destination(scenario.destination)
        xcodebuild.arguments.append("test")
        try xcodebuild.run(workflow: workflow)
    }

    private func parse() throws {
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

        try XCPParser().extractAttachments(
            xcresultPath: xcresultPath(),
            destination: task.saveDirectory,
            options: options
        )
    }

    private func xcresultPath() throws -> String {
        let testDirectory = try buildSettings.derivedDataTestDirectory()
        guard let folder = try Folder(path: testDirectory)
            .subfolders.filter({ $0.name.contains(".xcresult") && $0.name.contains(task.uiTestScheme) })
            .sorted(by: { f1, f2 in
                return try f1.file(named: "Info.plist").modificationDate > f2.file(named: "Info.plist").modificationDate
            })
            .first
        else {
            throw PumaError.invalid
        }

        return folder.path
    }
}
