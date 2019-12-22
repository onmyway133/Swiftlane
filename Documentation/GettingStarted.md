## Getting Started

Hi! Welcome to Puma, a pure Swift build tool utilities designed to easy mobile application development and deployment. Unlike other command line tools, Puma is designed to be used as a Swift package, which means it is just Swift code and you have total control over the program.

The recommended way to integrate Puma is via [Swift Package Manager](https://swift.org/package-manager/), although you are free to use any package manager that you like.

## Creating executable

With Swift Package Manager, started by creatiing an executable and add Puma as a dependency

```sh
mkdir MyBuildTool
cd MyBuildTool
swift package init --type executable
```

Inside your `Package.swift`, add Puma as dependencies

```swift
import PackageDescription

let package = Package(
    name: "Puma",
    platforms: [.macOS("10.15")],
    products: [
        .library(name: "MyBuildTool", targets: ["MyBuildTool"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/pumaswift/Puma.git",
            .upToNextMajor(from: "0.0.1")
        )
    ]
)
```

Go to MyBuildTool/Sources/MyBuildTool/main.swift and start using tasks from Puma

```swift
import Foundation
import Puma
import PumaCore
import PumaiOS

run {
    PrintWorkingDirectory()
    
    RunScript {
        $0.script = "echo 'Hello Puma'"
    }
    
    SetVersionNumber {
        $0.isEnabled = false
        $0.versionNumberForAllTargets("1.1")
    }
    
    SetBuildNumber {
        $0.isEnabled = false
        $0.buildNumberForAllTargets("2")
    }
    
    Build {
        $0.isEnabled = false
        $0.configure(projectType: .project("TestApp"), scheme: "TestApp")
        $0.buildsForTesting = true
    }
}
```

Now build and run, Swift Package Manager wil fetch all dependencies and build your executable

```sh
swift build
swift run
```

## Task and Workflow

The core of Puma is `Task`. When you call `run` above, it actually uses `Workflow`, which is a group of tasks. `Workflow` is intended for cases where you need to run tasks for multiple projects.

```swif
run {
    Build
    Test
}
```

is the same as

```swift
let workflow = Workflow {
    Build
    Test
}

workflow.run()
```

## Frameworks inside Puma

Puma is declared as a library, and it has some dependencies

### Puma

The facade, which exposes convenient `run` function, and incudes other frameworks

### PumaCore

Contains the core utilities, Task protocol and some core tasks

- PrintWorkingDirectory: prints the current working directory
- RunScript: run arbitrary shell script
- Sequence: run sub tasks in sequence
- Concurrent: run sub tasks in parallel

### PumaiOS

Contains iOS related tasks.

- Build: build workspace or project
- Test: test workspace or project
- Archive: archive to xcarchive
- ExportArchive: export archive into .ipa
- Screenshot: automate screenshot capturing, you can specify device, sdk, version, language and locale. It also supports test plan in Xcode 11

### PumaAndroid

Contains Android related tasks. TBD

### PumaExtra

Contains extra tasks

- Slack: interact with Slack
- AppStoreConnect: interact with AppStore Connect
- AppDistribution: interact with Firebase AppDistribution
- Crashlytics: interact with Firebase Crashlytics