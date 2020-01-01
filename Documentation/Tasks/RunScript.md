## Run arbirary script

This is used to run arbitrary command line scripts.

```swift
RunScript {
    $0.script = "echo 'Hello Puma'"
}

RunScript {
    $0.script = "git tag 1.0.0"
}
```