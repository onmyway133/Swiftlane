## Upload app to AppStore Connect

Upload ipa file to AppStore Connect

```swift
UploadApp {
    $0.authenticate(
        username: ProcessInfo().environment["username"]!,
        password: ProcessInfo().environment["password"]!
    )

    $0.upload(
        ipaPath: Directory.downloads.appendingPathComponent("TestApp.ipa").path
    )
}
```