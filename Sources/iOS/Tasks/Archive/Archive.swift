//
//  Archive.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 PumaSwift. All rights reserved.
//

import Foundation
import PumaCore

public class Archive {
    public var name: String = "Archive"
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()

    public init() { }
}

// MARK: - Modifiers

public extension Archive {
	func projectType(_ projectType: ProjectType, archivePath path: String? = nil) -> Self {
		xcodebuild.projectType(projectType)
		if let path = path {
			xcodebuild.archivePath(path, name: projectType.name)
		}
		return self
	}

	func scheme(_ scheme: String) -> Self {
		xcodebuild.scheme(scheme)
		return self
	}
}

// MARK: - Task

extension Archive: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            xcodebuild.arguments.append("archive")
            try xcodebuild.run(workflow: workflow)
        }
    }
}
