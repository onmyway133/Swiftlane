## Download metadata for an app from AppStore Connect

This task use a script from [Transporter](https://apps.apple.com/us/app/transporter/id1450874784?mt=12), you should download it from AppStore first.

```swift
DownloadMetadata {
    $0.authenticate(
        username: ProcessInfo().environment["username"]!,
        appSpecificPassword: ProcessInfo().environment["password"]!
    )

    $0.download(
        appSKU: "com.onmyway133.KeyFighter",
        saveDirectory: Directory.downloads.path
    )
}
```