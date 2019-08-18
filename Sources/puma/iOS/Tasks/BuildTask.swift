import Foundation

public struct BuildTask {
    public let options: Options
    public let extend: Extend
    
    public init(options: Options, extend: Extend = Extend()) {
        self.options = options
        self.extend = extend
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
        let arguments = buildArgument(options.toArguments(), extend: extend.argument)
        let command = buildCommand("xcodebuild \(arguments) build", extend: extend.command)
        Log.command(command)
        _ = try Process().run(command: command, processHandler: DefaultProcessHandler())
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
    func toArguments() -> [String: String?] {
        let arguments = buildOptions.toArguments()
        
        return arguments
            .simpleMerging([
                "build-for-testing": buildsForTesting ? "": nil
            ])
    }
}
