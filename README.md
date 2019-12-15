# Puma

Puma is a set of build utilities to automate mobile application development and deployment.

- Puma and its dependencies are written in pure Swift, making it easy to read and contribute.
- Use latest Swift 5.1 features like function builder to enable declarative syntax
- Type-safe. All required and optional arguments are clear.
- No configuration file. Your Swift script is your definition.
- Simple wrapper around existing tools like xcodebuild, instruments and agvtool
- Reuse awesome Swift scripting dependencies from Swift community

Puma is intended to be used as a Swift library. Just import in your Swift script file and run. There's no additional configuration file, your Swift script file is the source of truth. 

## How to

### Test drive Puma

To see Puma in action, head over to [TestPuma](https://github.com/pumaswift/Puma/tree/develop/Example/TestPuma), there is a TestPuma Command Line Tool macOS project with a `main.swift`.

You need to tweak the `teamId` and options according to your project.

```swift
func testDrive() {
    let workflow = Workflow(name: "TestApp") {
        WorkingDirectory()

        SetVersionNumber {
            $0.versionNumberForAllTargets("1.1")
        }

        SetBuildNumber {
            $0.buildNumberForAllTargets("2")
        }

        Build {
            $0.default(project: "TestApp", scheme: "TestApp")
            $0.buildsForTesting(enabled: true)
        }

        Test {
            $0.default(project: "TestApp", scheme: "TestApp")
            $0.testsWithoutBuilding(enabled: true)
            $0.destination(.init(
                platform: Destination.Platform.iOSSimulator,
                name: Destination.Name.iPhoneXr,
                os: Destination.OS.os12_2
            ))
        }

        Screenshot {
            $0.take(scenario: .init(
                destination: .init(
                    platform: Destination.Platform.iOSSimulator,
                    name: Destination.Name.iPhoneX,
                    os: Destination.OS.os12_2
                ),
                language: Language.en_US,
                locale: Locale.en_US)
            )

            $0.take(scenario: .init(
                destination: .init(
                    platform: Destination.Platform.iOSSimulator,
                    name: Destination.Name.iPhoneX,
                    os: Destination.OS.os12_2
                ),
                language: Language.ja,
                locale: Locale.ja)
            )
        }
    }

    workflow.workingDirectory = "/Users/khoa/XcodeProject2/Puma/Example/TestApp"
    workflow.run(completion: { _ in })
}
```

### Compile Puma

Head over to [Swift Package Manager usage](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) to create an executable.

There's an already created [ManualCompile](https://github.com/pumaswift/Puma/tree/develop/Example/TestApp/ManualCompile) for your reference.

Step 1: In your project folder, run these to create Swift Package Manager structure. Create another folder called, for example ManulCompile to keep our script.

```sh
mkdir ManualCompile
cd ManualCompile
swift package init --type executable
```

Step 2: Edit the newly generated `Package.swift` to include Puma

```swift
// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ManualCompile",
    platforms: [.macOS("10.14")],
    dependencies: [
        .package(
            url: "https://github.com/pumaSwift/Puma.git",
            .upToNextMajor(from: "0.0.1")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ManualCompile",
            dependencies: [
                "Puma"
            ]
        ),
        .testTarget(
            name: "ManualCompileTests",
            dependencies: ["ManualCompile"]),
    ]
)
```

Step 3: Go to ManualCompile/Sources/ManualCompile/main.swift, import Puma and declare the tasks. 

Step 4: Run 

```
swift build
```

This will fetch dependencies and build our executable.

Step 5: Copy the built ManualCompile executable from `Example/TestApp/ManualCompile/.build/debug/ManualCompile` to our `TestApp` folder

```sh
cp -f ./.build/debug/ManualCompile ../puma
```

Now we should have the executable `puma` in our project folder.

Step 6: In our project folder, run `./puma` to see Puma in action

```
./puma
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
- [xcparse](https://github.com/ChargePoint/xcparse) Command line tool & Swift framework for parsing Xcode 11+ xcresult

## FAQ

### Compare with others

The idea for making scripts to automate things is not new. Some other tools are battled tested and deal with edge cases, and of course more awesome than Puma.

Starting from our internal need to automate some small tasks, we hope to extend Puma to deal with more common mobile application development and deployment use cases. There are existing Xcode commands like xcodebuild, instruments, avgtool and other awesome scriptings from Swift community, our job is to connect things up and make them a little bit nicer.

### Why Swift

Swift is a type-safe language. The compiler guides you through completing all the required parameters, which makes it clear what information are needed for a specific task. There is no automatic detector, assumptions and asking us at runtime. No user interaction should be required when running.

The project is not just for a declarative Swift syntax shell. The code is in pure Swift, which helps contributors to easily reason about the code.

With Swift Package Manager, you can just import Puma to declare the tasks, and extend the framework the way you want. There is no additional configuration file, your Swift file is the source of truth.

With Swift Package Manager and GitHub Package Registry support for Swift packages, we believe Swift scripting will become the norm.

## Contributing

Puma is in its early development, we need your help.



