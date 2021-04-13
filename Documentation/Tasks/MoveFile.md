## Move a file to another location

Use to move a file to another location, this is nifty to organize build and sign artifacts. The path must be absolute and contains file name and extension.

```swift
MoveFile(
    from: Directory.downloads.appendingPathComponent("cert.md").path,
    to: Directory.downloads.appendingPathComponent("ProductionCertificate.md").path 
)
```
