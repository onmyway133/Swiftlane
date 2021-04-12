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
	Workflow {
		PrintWorkingDirectory()

		Wait(seconds: 2)

		Retry(times: 2) {
			PrintWorkingDirectory()
		}

		RunScript(script: "echo 'Hello Puma'")
			.name("Hello Puma")

		DownloadMetadata(appSKU: "com.onmyway133.KeyFighter", saveDirectory: Directory.downloads.path)
			.username(ProcessInfo().environment["username"]!)
			.password(ProcessInfo().environment["password"]!)

		SetVersionNumber("1.1")
			.enable(false)

		ShowAvailableDestinations()

		SetBuildNumber("3")

		BootSimulator(Destination(name: "iPhone 8 Plus", platform: .iOS, os: "13.2"))
			.enable(false)

		Build(forTesting: true)
			.project("TestApp")
			.scheme("TestApp")

		Test(withoutBuilding: true)
			.project("TestApp")
			.scheme("TestApp")
			.destination(Destination(name: Destination.Name.iPhone11, platform: .iOSSimulator, os: Destination.OS.iOS13_2_2))

		Screenshot()
			.enable(false)
			.project("TestApp")
			.appScheme("TestApp")
			.uiTestScheme("TestAppUITests")
			.saveDirectory(Directory.downloads.appendingPathComponent("PumaScreenshots").path)
			.scenarios(
				.init(
					destination: .init(
						name: Destination.Name.iPhone11,
						platform: .iOSSimulator,
						os: Destination.OS.iOS13_2_2
					),
					language: Language.en_US,
					locale: Locale.en_US
				),
				.init(
					destination: .init(
						name: Destination.Name.iPhone11Pro,
						platform: .iOSSimulator,
						os: Destination.OS.iOS13_2_2
					),
					language: Language.ja,
					locale: Locale.ja
				)
			)

		Archive()
			.enable(false)
			.projectType(.project("TestApp"), archivePath: Directory.downloads.appendingPathComponent("TestApp.xcarchive").path)
			.scheme("TestApp")

		let exportOptions = ExportArchive.ExportOptions(
			method: ExportArchive.ExportMethod.development,
			signing: .automatic(.init(teamId: ProcessInfo().environment["teamId"]!))
		)
		ExportArchive(options: .options(exportOptions))
			.enable(false)
			.projectType(.project("TestApp"), archivePath: Directory.downloads.appendingPathComponent("TestApp.xcarchive").path)
			.exportPath(Directory.downloads.path)

		UploadApp(path: Directory.downloads.appendingPathComponent("TestApp.ipa").path)
			.enable(false)
			.username(ProcessInfo().environment["username"]!)
			.password(ProcessInfo().environment["password"]!)

		Slack {
			Slack.Message(
				token: ProcessInfo().environment["slackBotToken"]!,
				channel: "random",
				text: "Hello from Puma",
				username: "onmyway133"
			)
		}
	}
	.workingDirectory(Directory.home.appendingPathComponent("XcodeProject2/Puma/Example/TestApp").path)
	.logger(FileLogger(saveFilePath: Directory.downloads.appendingPathComponent("puma.log").path))
	.run()
}

testDrive()
