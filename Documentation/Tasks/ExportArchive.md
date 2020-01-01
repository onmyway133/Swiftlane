## Export archive to ipa

Export xcarchive to ipa file. You need to specify manual or automatic code signing.

```swift
ExportArchive {
    $0.configure(
        projectType: .project("TestApp"),
        archivePath: Directory.downloads.appendingPathComponent("TestApp.xcarchive").path,
        optionsPlist: .options(
            .init(
                method: ExportArchive.ExportMethod.development,
                signing: .automatic(
                    .init(teamId: ProcessInfo().environment["teamId"]!)
                )
            )
        ),
        exportDirectory: Directory.downloads.path
    )
}
```