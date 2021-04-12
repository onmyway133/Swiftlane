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
    public var name: String = "Screenshot"
    public var isEnabled = true

	var xcodebuild = Xcodebuild()

    var saveDirectory: String = "."
	var uiTestScheme: String = ""

    private var scenarios = [Scenario]()
    private var appScheme: String = ""

    public init() {
		xcodebuild.sdk(Sdk.iPhoneSimulator)
    }
}

// MARK: - Modifiers

public extension Screenshot {
	func project(_ name: String) -> Self {
		xcodebuild.projectType(.project(name))
		return self
	}

	func workspace(_ name: String) -> Self {
		xcodebuild.projectType(.workspace(name))
		return self
	}

	func scheme(_ scheme: String) -> Self {
		xcodebuild.scheme(scheme)
		return self
	}

	func uiTestScheme(_ scheme: String) -> Self {
		uiTestScheme = scheme
		return self
	}

	func configuration(_ configuration: String) -> Self {
		xcodebuild.configuration(configuration)
		return self
	}

	func sdk(_ sdk: String) -> Self {
		xcodebuild.sdk(sdk)
		return self
	}

	func appScheme(_ appScheme: String) -> Self {
		self.appScheme = appScheme
		return self
	}

	func saveDirectory(_ saveDirectory: String) -> Self {
		self.saveDirectory = saveDirectory
		return self
	}

	func testPlan(_ path: String) -> Self {
		xcodebuild.testPlan(path)
		return self
	}

	func scenarios(_ scenarios: Scenario...) -> Self {
		self.scenarios.append(contentsOf: scenarios)
		return self
	}
}

// MARK: - Task

extension Screenshot: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        do {
            try Folder.createFolderIfNeeded(path: saveDirectory)
            let getBuildSettings = GetBuildSettings(xcodebuild: xcodebuild)
            let buildSettings = try getBuildSettings.get(workflow: workflow, appScheme: appScheme)

            let subTasks: [SubTask] = scenarios.map({ scenario in
                return SubTask(
                    scenario: scenario,
                    task: self,
                    buildSettings: buildSettings
                )
            })

            Sequence(tasks: subTasks).run(workflow: workflow, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}
