## Workflow

`Workflow` is the executation context, which groups and runs all tasks sequentially using `Sequence` task. `Workflow` handles error by printing it to the console.

You can use `Workflow` however you like, but it is designed to be used in multiple projects or a project with different build flavors. You can also have 1 `Workflow` for building related tasks, and another `Workflow` for archiving and uploading tasks. 

`Workflow` has a `name` property where you can use to identify a certain workflow.

## Working directory

By default, all tasks in workflow is related to the current executable running directory, you can change that by configuring `workingDirectory` property.

```swift
let workflow = Workflow {
    Build()
    Test()
}

workflow.name = "My primary workflow"
workflow.workingDirectory = Directory.home.appendingPathComponent("XcodeProject2/Puma/Example/TestApp").path
```

## Summarizer

Workflow has a `Summarizer` where it lists all running tasks when workflow starts, and a summarizer with running duration when workflow finishes. Here is a sample summary.

```
  1. ✅ Print working directory (0s)
  2. ✅ Wait (2s)
  3. ✅ Retry (0s)
  4. ✅ Run script (0s)
  5. ✅ Download app metadata from AppStore Connect (8s)
  6. ☑️ Set version number (0s)
  7. ✅ Show available destinations (0s)
  8. ✅ Set build number (0s)
  9. ☑️ Boot simulator (0s)
  10. ✅ Build (2s)
  11. ✅ Test (11s)
  12. ☑️ Screenshot (0s)
  13. ☑️ Archive (0s)
  14. ☑️ Export archive (0s)
  15. ☑️ Upload app to AppStore Connect (0s)
  16. ❌ Send message to Slack (0s)
```


## Logger

By default, Workflow uses `Console` logger which just prints to the console, you can configure to a `FileLogger` which saves logged content to a file of your choice. You can also customize by conforming to our `Logger` protocol

```swift
public protocol Logger {
    func log(_ string: String)
    func finalize() throws
}
```

Here is how to use `FileLogger`

```swift
let workflow = Workflow {
    Build()
    Test()
}

workflow.logger = FileLogger(saveFilePath: Directory.downloads.appendingPathComponent("puma.log").path)
```