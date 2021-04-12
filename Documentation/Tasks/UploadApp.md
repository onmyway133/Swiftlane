## Upload app to AppStore Connect

Upload ipa file to AppStore Connect

```swift
UploadApp(path: Directory.downloads.appendingPathComponent("TestApp.ipa").path)
	.username(ProcessInfo().environment["username"]!)
	.password(ProcessInfo().environment["password"]!)
```
