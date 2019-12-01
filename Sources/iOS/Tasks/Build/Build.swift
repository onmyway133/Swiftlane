import Foundation
import PumaCore

public class Build: UsesXcodeBuild {
    public var arguments = [String]()
    
    public init(_ closure: (Build) -> Void) {
        closure(self)
    }
}

extension Build: Task {
    public var name: String { "Build" }

    public func run() throws {
        arguments.append("build")
        try (self as UsesCommandLine).run()
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
