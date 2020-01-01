## Build project

You need to provide workspace or project, together with scheme

```swift
Build {
    $0.configure(projectType: .project("TestApp"), scheme: "TestApp")
    $0.buildsForTesting = true
}

```