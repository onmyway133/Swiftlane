import Foundation
import PumaCore

public class Build: UsesXcodeBuild {
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()
    
    public init(_ closure: (Build) -> Void = { _ in }) {
        closure(self)
    }
}

extension Build: Task {
    public var name: String { "Build" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            xcodebuild.arguments.append("build")
            try runXcodeBuild(workflow: workflow)
        }
    }
}

public extension Build {
    func buildsForTesting(enabled: Bool) {
        if enabled {
            xcodebuild.arguments.append("build-for-testing")
        } else {
            xcodebuild.arguments.remove("build-for-testing")
        }
    }
}
