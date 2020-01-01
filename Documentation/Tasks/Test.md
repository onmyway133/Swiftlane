## Test

Test whichever scheme having Test action. You can also configure testPlan

```swift
Test {
    $0.configure(projectType: .project("TestApp"), scheme: "TestApp")
    $0.testsWithoutBuilding = true
    $0.destination(
        .init(
            name: Destination.Name.iPhone11,
            platform: Destination.Platform.iOSSimulator,
            os: Destination.OS.iOS13_2_2
        )
    )
}

```