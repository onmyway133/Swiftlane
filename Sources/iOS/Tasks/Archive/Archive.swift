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
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()
    public var archivePath: String = ""

    public init(_ closure: (Archive) -> Void = { _ in }) {
        closure(self)
    }
}

extension Archive: Task {
    public var name: String { "Archive" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            xcodebuild.arguments.append("archive")
            try xcodebuild.run(workflow: workflow)
        }
    }
}

public extension Archive {
    func configure(
        project: String,
        scheme: String,
        archivePath: String
    ) {
        xcodebuild.project(project)
        xcodebuild.scheme(scheme)
        xcodebuild.archivePath(archivePath)
    }

    func configure(
        workspace: String,
        scheme: String,
        archivePath: String
    ) {
        xcodebuild.workspace(workspace)
        xcodebuild.scheme(scheme)
        xcodebuild.archivePath(archivePath)
    }
}
