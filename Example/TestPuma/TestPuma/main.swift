//
//  main.swift
//  TestPuma
//
//  Created by khoa on 30/11/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

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
            $0.configure(projectType: .project("TestApp"), scheme: "TestApp")
            $0.buildsForTesting = true
        }

        Test {
            $0.isEnabled = false
            $0.configure(projectType: .project("TestApp"), scheme: "TestApp")
            $0.testsWithoutBuilding = true
            $0.destination(.init(
                platform: Destination.Platform.iOSSimulator,
                name: Destination.Name.iPhone11,
                os: Destination.OS.iOS13_2_2
            ))
        }

        Screenshot {
            $0.isEnabled = true
            $0.configure(
                projectType: .project("TestApp"),
                appScheme: "TestApp",
                uiTestScheme: "TestAppUITests",
                saveDirectory: "/Users/khoa/Downloads/PumaScreenshots"
            )

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

        Archive {
            $0.isEnabled = false
            $0.configure(
                projectType: .project("TestApp"),
                scheme: "TestApp",
                archivePath: "/Users/khoa/Downloads/TestApp.xcarchive"
            )
        }

        ExportArchive {
            $0.isEnabled = false
            $0.configure(
                projectType: .project("TestApp"),
                archivePath: "/Users/khoa/Downloads/TestApp.xcarchive",
                optionsPlist: .options(.init(
                    teamId: "ABC123",
                    method: ExportArchive.ExportMethod.development)
                ),
                exportDirectory: "/Users/khoa/Downloads"
            )
        }
    }

    workflow.workingDirectory = "/Users/khoa/XcodeProject2/Puma/Example/TestApp"
    workflow.run()
}

testDrive()
