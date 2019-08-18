import Foundation

public struct BuildTask {
    public let options: Options
    
    public init(options: Options) {
        self.options = options
    }
}

extension BuildTask: Task {
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

public extension BuildTask {
    struct Options {
        let buildOptions: Xcodebuild.Options
        let buildsForTesting: Bool
        
        public init(buildOptions: Xcodebuild.Options, buildsForTesting: Bool = true) {
            self.buildOptions = buildOptions
            self.buildsForTesting = buildsForTesting
        }
    }
}

public extension BuildTask.Options {
    func toArguments() -> [String?] {
        return buildOptions.toArguments() + [
            buildsForTesting ? "build-for-testing" : nil
        ]
    }
}
