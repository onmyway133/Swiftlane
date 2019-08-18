# Puma

Puma is a set of build utilities to automate mobile application development and deployment.

## How to

Puma is intended to be used as a Swift library. Just import in your Swift script file and run. For simplicity, we can use [Marathon](https://github.com/JohnSundell/Marathon)

```swift
import Puma

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
    SetBuildNumber(options: .init(buildNumber: "2
    Build(options: .init(
        buildOptions: xcodebuildOptions,
        buildsForTesting: true)
  
    Test(options: .init(
        buildOptions: xcodebuildOptions,
        destination: Destination(
            platform: Destination.Platform.iOSSimulator,
            name: Destination.Name.iPhoneXr,
            os: Destination.OS.os12_2
        )
   
    Archive(options: .init(
        buildOptions: xcodebuildOptions,
        archivePath: recommendedArchiveOptions.archivePath
   
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

## Why

- Puma and its dependencies are written in pure Swift, making it easy to read and contribute.
- Use latest Swift 5.1 features like function builder to enable declarative syntax
- Type safe. All required and optional arguments are clear.
- No configuration file. Your Swift script is your definition.
- Simple wrapper around existing tools like xcodebuild, instruments and agvtool
- Reuse awesome Swift scripting dependencies from Swift community

## Road map

- [ ] Auto detect schemes and build settings
- [ ] Build for Android
- [ ] Post to chat services like Slack
- [ ] Interact with the new Appstore Connect API
- [ ] Integrate with services like Firebase
- [ ] Capture screenshots

## Contributing

Puma is in its early development, we need your help.


