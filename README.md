# Puma

Puma is a set of build utilities to automate mobile application development and deployment.

- Puma and its dependencies are written in pure Swift, making it easy to read and contribute.
- Use latest Swift 5.1 features like function builder to enable declarative syntax
- Type safe. All required and optional arguments are clear.
- No configuration file. Your Swift script is your definition.
- Simple wrapper around existing tools like xcodebuild, instruments and agvtool
- Reuse awesome Swift scripting dependencies from Swift community

## How to

Puma is intended to be used as a Swift library. Just import in your Swift script file and run. Here's an example using [Marathon](https://github.com/JohnSundell/Marathon)

```swift
import Puma // marathon:https://github.com/pumaswift/Puma.git

let automaticSigning = AutomaticSigning(teamId: "T78DK947F2")
let recommendedArchiveOptions = OptionFactory().makeArchiveOptions(name: "TestApp")

let xcodebuildOptions = Xcodebuild.Options(
    workspace: nil,
    project: "TestApp",
    scheme: "TestApp",
    configuration: Configuration.release,
    sdk: Sdk.iPhone,
    signing: .auto(automaticSigning),
    usesModernBuildSystem: true
)

run {
    SetVersionNumber(options: .init(buildNumber: "1.1"))
    SetBuildNumber(options: .init(buildNumber: "2"))
    Build(options: .init(
        buildOptions: xcodebuildOptions,
        buildsForTesting: true
    ))
    
    Test(options: .init(
        buildOptions: xcodebuildOptions,
        destination: Destination(
            platform: Destination.Platform.iOSSimulator,
            name: Destination.Name.iPhoneXr,
            os: Destination.OS.os12_2
        )
    ))
   
    Archive(options: .init(
        buildOptions: xcodebuildOptions,
        archivePath: recommendedArchiveOptions.archivePath
    ))
   
    ExportArchive(
        options: .init(
            exportOptionsPlist: nil,
            archivePath: recommendedArchiveOptions.archivePath,
            exportPath: recommendedArchiveOptions.exportPath
        ),
        exportPlist: .init(
            teamId: "T78DK947F2",
            method: ExportMethod.development
        )
    )
}
```

## Road map

- [ ] Auto detect schemes and build settings
- [ ] Build for Android
- [ ] Post to chat services like Slack
- [ ] Interact with the new Appstore Connect API
- [ ] Integrate with services like Firebase
- [ ] Capture screenshots

## Dependencies

- [xcbeautify](https://github.com/thii/xcbeautify) A little beautifier tool for xcodebuild
- [Colorizer](https://github.com/getGuaka/Colorizer) A Swift package that helps adding colors to strings written to the terminal.
- [Files](https://github.com/JohnSundell/Files) A nicer way to handle files & folders in Swift

## FAQ

### Compare with others

Idea for making scripts to automate things is not new. There are some other tools that are battled tested and deal with edge cases, and of course more awesome than Puma.

Starting from our internal need to automate some small tasts, we hope to extend Puma to deal with more common mobile application development and deployment use cases. There are existing Xcode commands like xcodebuild, instruments, avgtool and other awesome scriptings from Swift community, our job is to connect things up and make them little bit nicer.

### Why Swift

Swift is a type safe language. The compiler guides you through completing all the required parameters, which means it clear which are needed information for which task. There is no automatic detector, assumptions and asking us at runtime. No user interaction should be required when running.

The project is not just for a declarative Swift syntax shell. The code is in pure Swift, which helps contributors to easily reason about the code.

With Swift Package Manager, you can just import Puma to declare the tasks, and extend the framework the way you want. There is no additional configuration file, your Swift file is the source of truth.

With Swift Package Manager and GitHub Package Registry support for Swift packages, we believe Swift scripting will become the norm.

## Contributing

Puma is in its early development, we need your help.



