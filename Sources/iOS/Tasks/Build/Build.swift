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
    public var xcodebuild = Xcodebuild()
    public var buildsForTesting: Bool = false
    
    public init(_ closure: (Build) -> Void = { _ in }) {
        closure(self)
    }
}

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

public extension Build {
    func configure(
        projectType: ProjectType,
        scheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator
    ) {
        xcodebuild.projectType(projectType)
        xcodebuild.scheme(scheme)
        xcodebuild.configuration(configuration)
        xcodebuild.sdk(sdk)
    }

    func destination(_ destination: Destination) {
        xcodebuild.destination(destination)
    }
}
