//
//  Archive.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 PumaSwift. All rights reserved.
//

import Foundation
import PumaCore

public class Build {
    public var name = "Build"
    public var isEnabled = true

	private var xcodebuild = Xcodebuild()
    private let buildsForTesting: Bool
    
	public init(forTesting: Bool = false) {
		buildsForTesting = forTesting
    }
}

// MARK: - Modifiers

public extension Build {
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

	func configuration(_ configuration: String) -> Self {
		xcodebuild.configuration(configuration)
		return self
	}

	func destination(_ destination: Destination) -> Self {
		xcodebuild.destination(destination)
		return self
	}

	func arguments(_ arguments: String...) -> Self {
		xcodebuild.arguments.append(contentsOf: arguments)
		return self
	}
}

// MARK: - Task

extension Build: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            if buildsForTesting {
                xcodebuild.arguments.append("build-for-testing")
            } else {
                xcodebuild.arguments.append("build")
            }

            try xcodebuild.run(workflow: workflow)
        }
    }
}
