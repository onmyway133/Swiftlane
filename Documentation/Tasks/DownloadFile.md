## Download remote file and save to disk.

Download remote file and save to a specific location on disk. This is useful to download secrets or other build artifacts. The path must be absolute and contains file name and extension.

```swift
DownloadFile(URL(string: "https://myapp/com/secret?json=true")!)
    .destination(Directory.downloads.appendingPathComponent("secret.json").path)
```
