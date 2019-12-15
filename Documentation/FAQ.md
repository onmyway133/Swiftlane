## FAQ

### Compare with others

The idea for making scripts to automate things is not new. Some other tools are battled tested and deal with edge cases, and of course more awesome than Puma.

Starting from our internal need to automate some small tasks, we hope to extend Puma to deal with more common mobile application development and deployment use cases. There are existing Xcode commands like xcodebuild, instruments, avgtool and other awesome scriptings from Swift community, our job is to connect things up and make them a little bit nicer.

### Why Swift

Swift is a type-safe language. The compiler guides you through completing all the required parameters, which makes it clear what information are needed for a specific task. There is no automatic detector, assumptions and asking us at runtime. No user interaction should be required when running.

The project is not just for a declarative Swift syntax shell. The code is in pure Swift, which helps contributors to easily reason about the code.

With Swift Package Manager, you can just import Puma to declare the tasks, and extend the framework the way you want. There is no additional configuration file, your Swift file is the source of truth.

With Swift Package Manager and GitHub Package Registry support for Swift packages, we believe Swift scripting will become the norm.