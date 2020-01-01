## Task and Workflow

The core of Puma is `Task`. When you call `run` method, it actually uses `Workflow`, which is a group of tasks. `Workflow` is intended for cases where you need to run tasks for multiple projects.

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

## Workflow

`Workflow` is the executation context, which group and run all tasks sequentially using `Sequence` task. `Workflow` handles error by printing it to the console, it also tracks running tasks in its `Summarizer` so we get summary at the end. 

You can use `Workflow` however you like, but it is designed to be used in multiple projects or a project with different build flavors. You can also have 1 `Workflow` for building related tasks, and another `Workflow` for archiving and uploading tasks. 

`Workflow` has a `name` property where you can use to identify a certain workflow.

By default, all tasks in workflow is related to the current executable running directory, you can change that by configuring `workingDirectory` property.

```swift
let workflow = Workflow {
    Build()
    Test()
}

workflow.name = "My primary workflow"
workflow.workingDirectory = Directory.home.appendingPathComponent("XcodeProject2/Puma/Example/TestApp").path
```

## Task protocol

At the core of Puma sits the `Task` protocol, every task has a name, isEnabled flag and an action.

```swift
public typealias TaskCompletion = (Result<(), Error>) -> Void

public protocol Task: AnyObject {
    var name: String { get }
    var isEnabled: Bool { get }
    func run(workflow: Workflow, completion: @escaping TaskCompletion)
}
```

The `workflow` parameter in `run` function acts as the context for all the tasks. When a task completes, you need to invoke `completion` so workflow know when to execute the next task in the pipeline.

### Disable a task

Some times you want to temporarily disable a task, every task in Puma needs to conform to `Task` protocol, and there is required `isEnabled` property where you can toggle off a task

```swift
Build {
    $0.isEnabled = false
}
```

### Change name of a task

Every task has a default name, and this name is used when summarizing, to change the name of a task, assign a different name to `name` property

```swift
Build {
    $0.name = "Build my awesome app"
}
```

## A bunch of tasks

Puma comes with a bunch of predefined tasks for popular actions, and they are sat in respective framework.

### Puma

The facade, which exposes convenient `run` function, and incudes other frameworks

### PumaCore

Contains the core utilities, Task protocol and some core tasks

- PrintWorkingDirectory: prints the current working directory
- RunScript: run arbitrary shell script
- Sequence: run sub tasks in sequence
- Concurrent: run sub tasks in parallel
- DownloadFile: Download and save file
- MoveFile: Move file to another location
- [Slack](Tasks/Slack.md): send message as a bot to Slack

### PumaiOS

Contains iOS related tasks.

- Build: build workspace or project
- Test: test workspace or project
- Archive: archive to xcarchive
- ExportArchive: export archive into .ipa
- [Screenshot](Tasks/Screenshot.md): automate screenshot capturing, you can specify device, sdk, version, language and locale. It also supports test plan in Xcode 11
- UploadApp: upload, notarize, validate app with AppStore
- ShowDestinations: show all available destinations when building and testing
- BootSimulator: boot simulator
- UpdateSimulator: update statusbar of simulator. This is nifty before taking screenshots

### PumaAndroid

Contains Android related tasks. TBD

### PumaExtra

Contains extra tasks

- AppStoreConnect: interact with AppStore Connect
- AppDistribution: interact with Firebase AppDistribution
- Crashlytics: interact with Firebase Crashlytics


## A bunch of tasks