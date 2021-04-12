## Export archive to ipa

Export xcarchive to ipa file. You need to specify manual or automatic code signing.

```swift
let options = ExportArchive.ExportOptions(
	method: ExportArchive.ExportMethod.development,
	signing: .automatic(
		.init(teamId: ProcessInfo().environment["teamId"]!)
	)
)
ExportArchive(options: .options(options))
	.projectType(.project("TestApp"), archivePath: Directory.downloads.appendingPathComponent("TestApp.xcarchive").path)
	.exportPath(Directory.downloads.path)
```
