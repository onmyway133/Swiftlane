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
    let workflow = Workflow {
        PrintWorkingDirectory()

        Wait {
            $0.wait(for: 2)
        }

        Retry(times: 2) {
            PrintWorkingDirectory()
        }

        RunScript {
            $0.script = "echo 'Hello Puma'"
        }
        
        DownloadMetadata {
            $0.authenticate(
                username: ProcessInfo().environment["username"]!,
                appSpecificPassword: ProcessInfo().environment["password"]!
            )

            $0.download(
                appSKU: "com.onmyway133.KeyFighter",
                saveDirectory: Directory.downloads.path
            )
        }

        SetVersionNumber {
            $0.isEnabled = false
            $0.versionNumberForAllTargets("1.1")
        }

        ShowAvailableDestinations()

        SetBuildNumber {
            $0.isEnabled = true
            $0.buildNumberForAllTargets("3")
        }

        BootSimulator {
            $0.isEnabled = false
            $0.boot(destination: .init(name: "iPhone 8 Plus", platform: "iOS", os: "13.2"))
        }

        Build {
            $0.configure(projectType: .project("TestApp"), scheme: "TestApp")
            $0.buildsForTesting = true
        }

        Test {
            $0.configure(projectType: .project("TestApp"), scheme: "TestApp")
            $0.testsWithoutBuilding = true
            $0.destination(
                .init(
                    name: Destination.Name.iPhone11,
                    platform: Destination.Platform.iOSSimulator,
                    os: Destination.OS.iOS13_2_2
                )
            )
        }

        Screenshot {
            $0.isEnabled = false
            $0.configure(
                projectType: .project("TestApp"),
                appScheme: "TestApp",
                uiTestScheme: "TestAppUITests",
                saveDirectory: Directory.downloads.appendingPathComponent("PumaScreenshots").path
            )

            $0.add(scenarios: [
                .init(
                    destination: .init(
                        name: Destination.Name.iPhone11,
                        platform: Destination.Platform.iOSSimulator,
                        os: Destination.OS.iOS13_2_2
                    ),
                    language: Language.en_US,
                    locale: Locale.en_US
                ),
                .init(
                    destination: .init(
                        name: Destination.Name.iPhone11Pro,
                        platform: Destination.Platform.iOSSimulator,
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
                archivePath: Directory.downloads.appendingPathComponent("TestApp.xcarchive").path
            )
        }

        ExportArchive {
            $0.isEnabled = false
            $0.configure(
                projectType: .project("TestApp"),
                archivePath: Directory.downloads.appendingPathComponent("TestApp.xcarchive").path,
                optionsPlist: .options(
                    .init(
                        method: ExportArchive.ExportMethod.development,
                        signing: .automatic(
                            .init(teamId: ProcessInfo().environment["teamId"]!)
                        )
                    )
                ),
                exportDirectory: Directory.downloads.path
            )
        }

        UploadApp {
            $0.isEnabled = false
            $0.authenticate(
                username: ProcessInfo().environment["username"]!,
                appSpecificPassword: ProcessInfo().environment["password"]!
            )

            $0.upload(
                ipaPath: Directory.downloads.appendingPathComponent("TestApp.ipa").path
            )
        }

        Slack {
            $0.post(
                message: .init(
                    token: ProcessInfo().environment["slackBotToken"]!,
                    channel: "random",
                    text: "Hello from Puma",
                    username: "onmyway133"
                )
            )
        }
    }

    workflow.workingDirectory = Directory.home.appendingPathComponent("XcodeProject2/Puma/Example/TestApp").path
    workflow.logger = FileLogger(saveFilePath: Directory.downloads.appendingPathComponent("puma.log").path)
    workflow.run()
}

testDrive()
