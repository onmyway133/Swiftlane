import Foundation
import PumaCore

public class Build: UsesXcodeBuild {
    public var xcodebuildArguments = [String]()
    
    public init(_ closure: (Build) -> Void = { _ in }) {
        closure(self)
    }
}

extension Build: Task {
    public var name: String { "Build" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        run(workflow: workflow, completion: completion, job: {
            xcodebuildArguments.append("build")
            try runXcodeBuild(workflow: workflow)
        })
    }
}

public extension Build {
    func buildsForTesting(enabled: Bool) {
        if enabled {
            xcodebuildArguments.append("build-for-testing")
        } else {
            xcodebuildArguments.remove("build-for-testing")
        }
    }
}
