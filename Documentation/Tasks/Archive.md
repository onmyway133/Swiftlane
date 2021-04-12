## Archive

Create `xcarchive`

```swift
Archive()
	.projectType(.project("TestApp"), archivePath: Directory.downloads.appendingPathComponent("TestApp.xcarchive").path)
	.scheme("TestApp")
```
