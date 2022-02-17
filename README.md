# Swiftlane

Swiftlane contains a set of build utilities to speed up iOS and macOS development and deployment

There's no additional configuration file, your Swift script file is the source of truth. With auto 
completion and type safety, you are ensured to do the right things in Swiftlane.

- Swiftlane and its dependencies are written in pure Swift, making it easy to read and contribute.
- Use latest Swift features like async/await to enable declarative syntax
- Type-safe. All required and optional arguments are clear.
- No configuration file. Your Swift script is your definition.
- Simple wrapper around existing tools like xcodebuild, instruments and agvtool
- Reuse awesome Swift scripting dependencies from Swift community

## How to use

Swiftlane is intended to be used as a Swift Package. Please consult `Examples` folder for ways to integrate

- CLI: make a macOS Command Line Tool project
- Script: make an executable Swift Package

```swift
import Swiftlane
import AppStoreConnect

@main
struct Script {
    static func main() async throws {
        try await deployMyApp()
    }
    
    private static func deployMyApp() async throws {
        var workflow = Workflow()
        workflow.directory = Settings.fs
            .homeDirectory()
            .appendingPathComponent("Projects/swiftlane/Examples/MyApp")
        workflow.xcodeApp = URL(string: "/Applications/Xcode.app")
        
        let build = Build()
        build.project("MyApp")
        build.allowProvisioningUpdates()
        build.destination(platform: .iOSSimulator, name: "iPhone 13")
        build.workflow = workflow
        try await build.run()
        
        guard
            let issuerId = Settings.env["ASC_ISSUER_ID"],
            let privateKeyId = Settings.env["ASC_PRIVATE_KEY_ID"],
            let privateKey = Settings.env["ASC_PRIVATE_KEY"]
        else { return }
        
        let asc = try ASC(
            credential: AppStoreConnect.Credential(
                issuerId: issuerId,
                privateKeyId: privateKeyId,
                privateKey: privateKey
            )
        )
        
        try await asc.fetchCertificates()
        try await asc.fetchProvisioningProfiles()
        
        let keychain = try await Keychain.create(
            path: Keychain.Path(
                rawValue: Settings.fs
                    .downloadsDirectory
                    .appendingPathComponent("custom.keychain")),
            password: "keychain_password"
        )
        try await keychain.unlock()
        try await keychain.import(
            certificateFile: Settings.fs
                .downloadsDirectory
                .appendingPathComponent("abcpass.p12"),
            certificatePassword: "123"
        )
        
    }
}
```

## Actions

### iOS
- [x] Build: build project
- [x] Test: test project
- [x] Archive: archive project
- [x] ExportArchive: export archive
- [x] SetBuildNumber: set build number
- [x] SetVersion: set version
- [x] IncreaseBuildNumber: increase build number
- [x] AppStore Connect: use https://github.com/onmyway133/AppStoreConnect
- [x] GetBuildSettings: get project build settings
- [ ] GenerateIcon: generate app icon set
- [x] Screenshot: take screenshot
- [ ] Frame: frame screenshot
- [x] UploadASC: upload IPA to AppStore Connect

#### ASC

- [x] Fetch certificates
- [x] Fetch provisioning profiles
- [x] Save certificates into file system
- [x] Save profiles into file system
- [x] Install provisioning profile

#### Keychain

- [x] Create custom keychain
- [x] Unlock keychain
- [x] Import certificate into keychain

#### Simulator 

- [ ] Boot a simulator
- [ ] Update and style  simulator

#### Xcode

- [x] Print current Xcode path

### macOS
- [x] Notarize: notarize project
- [ ] MakeDMG: package as DMG
- [ ] Sparkle: update Spackle Appcast file

### Standard
- [x] Slack: send message to a Slack channel
- [x] RunScript: run arbitrary script
- [x] PrintWorkingDirectory: print current working directory
- [ ] UploadS3: upload to S3
- [ ] UploadAppCenter: upload to AppCenter
- [ ] UploadSetapp: upload to Setapp
- [x] Download: download file
- [x] MoveFile: move file
- [x] CopyFile: copy file
- [x] AppCenter: use appcenter-cli

## Settings

Configurations via `Settings`

- Console: log to console
- FileSystem: interact with file system
- Environment: read environment values
- CommandLine: run command line tools

## Credit

- Notarize: refactor from https://github.com/Mortennn/Notarize

## License
Swiftlane is released under the MIT license. See LICENSE for details.


