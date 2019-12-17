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
        projectType: ProjectType,
        scheme: String,
        archivePath: String
    ) {
        xcodebuild.projectType(projectType)
        xcodebuild.scheme(scheme)
        xcodebuild.archivePath(archivePath, name: scheme)
    }
}
