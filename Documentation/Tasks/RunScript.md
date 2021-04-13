## Run arbirary script

This is used to run arbitrary command line scripts.

```swift
RunScript("echo 'Hello Puma'")

RunScript("git tag 1.0.0")
    .name("Tag build")
```
