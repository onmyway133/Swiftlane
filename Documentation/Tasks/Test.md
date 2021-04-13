## Test

Test whichever scheme having Test action. You can also configure testPlan

```swift
Test(withoutBuilding: true)
    .project("TestApp")
    .scheme("TestApp")
    .destination(
        .init(
            name: Destination.Name.iPhone11,
            platform: Destination.Platform.iOSSimulator,
            os: Destination.OS.iOS13_2_2
        )
    )
```
