## Wait

Wait or delay the workflow for n seconds, this is useful to workaround some flakiness

```swift
Wait {
    $0.wait(for: 2)
}
```