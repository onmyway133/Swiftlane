import Foundation
import PumaCore

public class Build: UsesXcodeBuild {
    public var arguments = [String]()
    
    public init(_ closure: (Build) -> Void = { _ in }) {
        closure(self)
    }
}

extension Build: Task {
    public var name: String { "Build" }

    public func run(workflow: Workflow) throws {
        arguments.append("build")
        try runCommand()
    }
}

public extension Build {
    func buildsForTesting(enabled: Bool) {
        if enabled {
            arguments.append("build-for-testing")
        } else {
            arguments.remove("build-for-testing")
        }
    }
}
