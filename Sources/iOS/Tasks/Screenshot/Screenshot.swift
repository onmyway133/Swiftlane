//
//  Screenshot.swift
//  PumaiOS
//
//  Created by khoa on 09/12/2019.
//

import Foundation
import PumaCore
import Files

public class Screenshot {
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()

    var saveDirectory: String = "."
    var uiTestScheme: String = ""

    private var scenarios = [Scenario]()
    private var appScheme: String = ""

    public init(_ closure: (Screenshot) -> Void = { _ in }) {
        closure(self)
    }
}

extension Screenshot: Task {
    public var name: String { "Screenshot" }

    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        do {
            try Folder.createFolderIfNeeded(path: saveDirectory)
            let getBuildSettings = GetBuildSettings(xcodebuild: xcodebuild)
            let buildSettings = try getBuildSettings.run(workflow: workflow, appScheme: appScheme)

            let subTasks: [SubTask] = scenarios.map({ scenario in
                return SubTask(
                    scenario: scenario,
                    task: self,
                    buildSettings: buildSettings
                )
            })

            Concurrent(tasks: subTasks).run(workflow: workflow, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}

public extension Screenshot {
    func configure(
        project: String,
        appScheme: String,
        uiTestScheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator,
        saveDirectory: String
    ) {
        self.appScheme = appScheme
        self.uiTestScheme = uiTestScheme
        self.saveDirectory = saveDirectory

        xcodebuild.project(project)
        xcodebuild.scheme(uiTestScheme)
        xcodebuild.configuration(Configuration.debug)
        xcodebuild.sdk(Sdk.iPhoneSimulator)
    }

    func configure(
        workspace: String,
        appScheme: String,
        uiTestScheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator,
        saveDirectory: String
    ) {
        self.appScheme = appScheme
        self.uiTestScheme = uiTestScheme
        self.saveDirectory = saveDirectory

        xcodebuild.workspace(workspace)
        xcodebuild.scheme(uiTestScheme)
        xcodebuild.configuration(Configuration.debug)
        xcodebuild.sdk(Sdk.iPhoneSimulator)
    }

    func testPlan(_ path: String) {
        xcodebuild.testPlan(path)
    }

    func add(scenarios: [Scenario]) {
        self.scenarios.append(contentsOf: scenarios)
    }
}
