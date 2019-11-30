import Foundation
import PumaCore

public class Build: UsesXcodeBuild {
    public var arguments = Set<String>()
    
    public init(_ closure: (Build) -> Void) {
        closure(self)
    }
}

extension Build: Task {
    public var name: String {
        return "Build"
    }

    public func run() throws {
        arguments.insert("build")
        try (self as UsesCommandLine).run()
    }
}

public extension Build {
    func buildsForTesting(enabled: Bool) {
        if enabled {
            arguments.insert("build-for-testing")
        } else {
            arguments.remove("build-for-testing")
        }
    }
}
