## Developing Puma

To develop Puma, head over to [TestPuma](https://github.com/pumaswift/Puma/tree/develop/Example/TestPuma), there is a TestPuma Command Line Tool macOS project with a `main.swift`.

In Example folder, ther is a worksapce TestPuma, it contains

- TestPuma project: this is a macOS command line project to create executable
- Puma project
- TestApp: the test iOS app

### Generate Puma project

Since Swift Package Manager contains only sources, in order to work with Xcode, run the following command to generate Puma project

```sh
swift package generate-xcodeproj
```

### Run TestPuma

Open `Example/TestPuma.xcworkspace`, the Puma project has already been included. Select TestPuma scheme, in order to run

- You need to sign TestPuma target, the easiest way is to check Automatic Signing and select a team
- You need to sign all frameworks in Puma project. 


### Play around

You need to tweak the `teamId` and options according to your project.

```swift
import Foundation
import Puma
import PumaCore
import PumaiOS

func testDrive() {
    let workflow = Workflow(name: "TestApp") {
        PrintWorkingDirectory()

        RunScript {
            $0.script = "echo 'Hello Puma'"
        }

        SetVersionNumber {
            $0.isEnabled = false
            $0.versionNumberForAllTargets("1.1")
        }

        SetBuildNumber {
            $0.isEnabled = false
            $0.buildNumberForAllTargets("2")
        }

        Build {
            $0.isEnabled = false
            $0.configure(project: "TestApp", scheme: "TestApp")
            $0.buildsForTesting(enabled: true)
        }

        Test {
            $0.isEnabled = false
            $0.configure(project: "TestApp", scheme: "TestApp")
            $0.testsWithoutBuilding(enabled: true)
            $0.destination(.init(
                platform: Destination.Platform.iOSSimulator,
                name: Destination.Name.iPhone11,
                os: Destination.OS.iOS13_2_2
            ))
        }

        Screenshot {
            $0.configure(
                project: "TestApp",
                appScheme: "TestApp",
                uiTestScheme: "TestAppUITests"
            )
            $0.saveDirectory = "/Users/khoa/Downloads/PumaScreenshots"

            $0.add(scenarios: [
                .init(
                    destination: .init(
                        platform: Destination.Platform.iOSSimulator,
                        name: Destination.Name.iPhone11,
                        os: Destination.OS.iOS13_2_2
                    ),
                    language: Language.en_US,
                    locale: Locale.en_US
                ),
                .init(
                    destination: .init(
                        platform: Destination.Platform.iOSSimulator,
                        name: Destination.Name.iPhone11Pro,
                        os: Destination.OS.iOS13_2_2
                    ),
                    language: Language.ja,
                    locale: Locale.ja
                )
            ])
        }
    }

    workflow.workingDirectory = "/Users/khoa/XcodeProject2/Puma/Example/TestApp"
    workflow.run()
}

testDrive()
```

