## Run arbirary script

This is used to run arbitrary command line scripts.

```swift
RunScript(script: "echo 'Hello Puma'")

RunScript(script: "git tag 1.0.0")
	.name("Tag build")
```
