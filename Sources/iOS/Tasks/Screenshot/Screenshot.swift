//
//  Screenshot.swift
//  PumaiOS
//
//  Created by khoa on 09/12/2019.
//

import Foundation
import PumaCore

public class Screenshot {
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()
    public var saveDirectory: String = "."

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
            let getBuildSettings = GetBuildSettings(xcodebuild: xcodebuild)
            let buildSettings = try getBuildSettings.run(workflow: workflow, appScheme: appScheme)

            guard let derivedDataDirectory = buildSettings.derivedDataDirectory() else {
                completion(.failure(PumaError.invalid))
                return
            }

            let subTasks: [SubTask] = scenarios.map({ scenario in
                return SubTask(
                    scenario: scenario,
                    xcodebuild: xcodebuild,
                    derivedDataPath: derivedDataDirectory,
                    savePath: saveDirectory
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
        uiTestsScheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator,
        usesModernBuildSystem: Bool = true
    ) {
        self.appScheme = appScheme

        xcodebuild.project(project)
        xcodebuild.scheme(uiTestsScheme)
        xcodebuild.configuration(Configuration.debug)
        xcodebuild.sdk(Sdk.iPhoneSimulator)
        xcodebuild.usesModernBuildSystem(enabled: true)
    }

    func configure(
        workspace: String,
        appScheme: String,
        uiTestsScheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator,
        usesModernBuildSystem: Bool = true
    ) {
        self.appScheme = appScheme

        xcodebuild.workspace(workspace)
        xcodebuild.scheme(uiTestsScheme)
        xcodebuild.configuration(Configuration.debug)
        xcodebuild.sdk(Sdk.iPhoneSimulator)
        xcodebuild.usesModernBuildSystem(enabled: true)
    }

    func testPlan(_ path: String) {
        xcodebuild.testPlan(path)
    }

    func add(scenarios: [Scenario]) {
        self.scenarios.append(contentsOf: scenarios)
    }
}
