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
    public var saveDirectory: String = "."
    public private(set) var scenarios = [Scenario]()

    public init(_ closure: (Screenshot) -> Void = { _ in }) {
        closure(self)
    }
}

extension Screenshot: Task {
    public var name: String { "Screenshot" }

    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        Deps.console.note("Please use UITest scheme")

        do {
            let getBuildSettings = GetBuildSettings(xcodebuild: xcodebuild)
            let buildSettings = try getBuildSettings.run(workflow: workflow)

            guard let derivedDataDirectory = buildSettings.value(forKey: .derivedDataDirectory) else {
                completion(.failure(PumaError.invalid))
                return
            }

            let subTasks: [SubTask] = scenarios.map({ scenario in
                var xcodebuild = self.xcodebuild
                xcodebuild.derivedData(derivedDataDirectory)
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
    func add(scenarios: [Scenario]) {
        self.scenarios.append(contentsOf: scenarios)
    }
}
