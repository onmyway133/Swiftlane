import Foundation
import PumaCore

public struct Build {
    public let options: Options
    
    public init(options: Options) {
        self.options = options
    }
}

extension Build: Task {
    public var name: String {
        return "Build"
    }
    
    public func validate() throws {
        try Validator.deviceBuildMustHaveCodeSign(options: options.buildOptions)
    }
    
    public func run() throws {
        let command = "xcodebuild \(toString(arguments: options.toArguments())) build"
        Log.command(command)
        _ = try Process().run(command: command)
    }
}

public extension Build {
    struct Options {
        let buildOptions: Xcodebuild.Options
        let buildsForTesting: Bool
        
        public init(buildOptions: Xcodebuild.Options, buildsForTesting: Bool = true) {
            self.buildOptions = buildOptions
            self.buildsForTesting = buildsForTesting
        }
    }
}

public extension Build.Options {
    func toArguments() -> [String?] {
        return buildOptions.toArguments() + [
            buildsForTesting ? "build-for-testing" : nil
        ]
    }
}
