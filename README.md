# Puma

Puma is a set of build utilities to automate mobile application development and deployment.

Unlike other command line tool that you need to understand lots of command line arguments, Puma is intended to be used as a Swift library. Just import in your Swift script file and run. There's no additional configuration file, your Swift script file is the source of truth. With auto completion and type safety, you are ensured to do the right things in Puma.

- Puma and its dependencies are written in pure Swift, making it easy to read and contribute.
- Use latest Swift 5.1 features like function builder to enable declarative syntax
- Type-safe. All required and optional arguments are clear.
- No configuration file. Your Swift script is your definition.
- Simple wrapper around existing tools like xcodebuild, instruments and agvtool
- Reuse awesome Swift scripting dependencies from Swift community

## Documentation

- [Getting Started](Documentation/GettingStarted.md)
- [Develop](Documentation/Develop.md)
- [Compile Puma from source](Documentation/Compile.md)
- [Tasks in Puma](Documentation/Tasks/README.md)
- [Dependencies](Documentation/Dependencies.md)
- [FAQ](Documentation/FAQ.md)

## Road map

- [ ] Auto detect schemes and build settings
- [ ] Build for Android
- [ ] Post to chat services like Slack
- [ ] Interact with the new Appstore Connect API
- [ ] Integrate with services like Firebase
- [ ] Capture screenshots

## Contributing

Puma is in its early development, we need your help.

## License
Puma is released under the MIT license. See [LICENSE](LICENSE) for details.

