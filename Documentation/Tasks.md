## Task and Workflow

The core of Puma is `Task`. When you call `run` method, it actually uses `Workflow`, which is a group of tasks. `Workflow` is intended for cases where you need to run tasks for multiple projects.

```swif
run {
    Build()
    Test()
}
```

is the same as

```swift
let workflow = Workflow {
    Build()
    Test()
}

workflow.run()
```

## Task protocol

At the core of Puma sits the `Task` protocol, every task has a `name`, `isEnabled` flag and an action.

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

Some times you want to temporarily disable a task, every task in Puma needs to conform to `Task` protocol, and there is a modifier `enable(_:)` where you can toggle on/off a task

```swift
Build()
    .enable(false)
```

### Change name of a task

Every task has a default name, and this name is used when summarizing, to change the name of a task, assign a different name using the `name(_:)` modifier

```swift
Build()
    .name("Build my awesome app")
```

## A bunch of tasks

Puma comes with a bunch of predefined tasks for popular actions, and they are sat in respective framework.

### Puma

The facade, which exposes convenient `run` function, and includes other frameworks

### PumaCore

Contains the core utilities, Task protocol and some core tasks

- [PrintWorkingDirectory](Tasks/PrintWorkingDirectory.md): prints the current working directory
- [RunScript](Tasks/RunScript.md): run arbitrary shell script
- [Sequence](Tasks/Sequence.md): run sub tasks in sequence
- [Concurrent](Tasks/Concurrent.md): run sub tasks in parallel
- [DownloadFile](Tasks/MoveFile.md): Download and save file
- [MoveFile](Tasks/MoveFile.md): Move file to another location
- [Slack](Tasks/Slack.md): send message as a bot to Slack
- [Wait](Tasks/Wait.md): wait for some time before moving to the next task
- [Retry](Tasks/Retry.md): retry a task n number of times.

### PumaiOS

Contains iOS related tasks.

- [Build](Tasks/Build.md): build workspace or project
- [Test](Tasks/Test.md): test workspace or project
- [Archive](Tasks/Archive.md): archive to xcarchive
- [ExportArchive](Tasks/ExportArchive.md): export archive into .ipa
- [Screenshot](Tasks/Screenshot.md): automate screenshot capturing, you can specify device, sdk, version, language and locale. It also supports test plan in Xcode 11
- [UploadApp](Tasks/UploadApp.md): upload, notarize, validate app with AppStore
- [ShowDestinations](Task/ShowDestinations.md): show all available destinations when building and testing
- [BootSimulator](Tasks/BootSimulator.md): boot simulator
- [UpdateSimulator](Tasks/UpdateSimulator.md): update statusbar of simulator. This is nifty before taking screenshots
- [DownloadMetadata](Tasks/DownloadMetadata.md): download metadata from AppStore Connect

### PumaAndroid

Contains Android related tasks. TBD

### PumaExtra

Contains extra tasks

- AppStoreConnect: interact with AppStore Connect
- AppDistribution: interact with Firebase AppDistribution
- Crashlytics: interact with Firebase Crashlytics


## A bunch of tasks
