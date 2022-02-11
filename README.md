# Swiftlane

Swiftlane contains a set of build utilities to speed up iOS and macOS development and deployment

There's no additional configuration file, your Swift script file is the source of truth. With auto 
completion and type safety, you are ensured to do the right things in Puma.

- Swiftlane and its dependencies are written in pure Swift, making it easy to read and contribute.
- Use latest Swift features like async/await to enable declarative syntax
- Type-safe. All required and optional arguments are clear.
- No configuration file. Your Swift script is your definition.
- Simple wrapper around existing tools like xcodebuild, instruments and agvtool
- Reuse awesome Swift scripting dependencies from Swift community

## How to use

Swiftlane is intended to be used as a Swift Package. Simply import it into your Swift script file

```swift
import Swiftlane

func deployMyAwesomeApp() async throws {
    let build = Build()
    build.project("MyAwesomeApp")
    build.scheme("Production")
    build.configuration(.release)
    try await build.run()
    
    let archive = Archive()
    // configure action
    try await archive.run()
    
    let testflight = Testflight()
    // configure action
    try await testflight.run() 
    
    let slack = Slack()
    slack.send(
        message: Slack.Message(text: "Deploy complete")
    ) 
}
```

## License
Swiftlane is released under the MIT license. See LICENSE for details.


