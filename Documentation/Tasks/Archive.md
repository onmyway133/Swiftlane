## Archive

Create `xcarchive`

```swift
Archive {
    $0.configure(
        projectType: .project("TestApp"),
        scheme: "TestApp",
        archivePath: Directory.downloads.appendingPathComponent("TestApp.xcarchive").path
    )
}
```