import Foundation
import PumaCore

public class Build {
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()
    public var buildsForTesting: Bool = false
    
    public init(_ closure: (Build) -> Void = { _ in }) {
        closure(self)
    }
}

extension Build: Task {
    public var name: String { "Build" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
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
        project: String,
        scheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator,
        usesModernBuildSystem: Bool = true
    ) {
        xcodebuild.project(project)
        xcodebuild.scheme(scheme)
        xcodebuild.configuration(Configuration.debug)
        xcodebuild.sdk(Sdk.iPhoneSimulator)
        xcodebuild.usesModernBuildSystem(enabled: true)
    }

    func configure(
        workspace: String,
        scheme: String,
        configuration: String = Configuration.debug,
        sdk: String = Sdk.iPhoneSimulator,
        usesModernBuildSystem: Bool = true
    ) {
        xcodebuild.workspace(workspace)
        xcodebuild.scheme(scheme)
        xcodebuild.configuration(Configuration.debug)
        xcodebuild.sdk(Sdk.iPhoneSimulator)
        xcodebuild.usesModernBuildSystem(enabled: true)
    }

    func destination(_ destination: Destination) {
        xcodebuild.destination(destination)
    }
}
