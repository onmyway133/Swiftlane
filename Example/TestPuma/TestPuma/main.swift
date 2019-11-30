//
//  main.swift
//  TestPuma
//
//  Created by khoa on 30/11/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation
import Puma
import PumaiOS

func testDrive() {
//    let automaticSigning = AutomaticSigning(teamId: "T78DK947F2")
//    let recommendedArchiveOptions = OptionFactory().makeArchiveOptions(name: "TestApp")
//
//    let xcodebuildOptions = Xcodebuild.Options(
//        workspace: nil,
//        project: "TestApp",
//        scheme: "TestApp",
//        configuration: Configuration.release,
//        sdk: Sdk.iPhone,
//        signing: .auto(automaticSigning),
//        usesModernBuildSystem: true
//    )

    run {
        SetVersionNumber {
            $0.versionNumberForAllTargets("1.1")
        }

        SetBuildNumber {
            $0.buildNumberForAllTargets("2")
        }

        Build {
            $0.default(project: "TestApp", scheme: "TestApp")
            $0.buildsForTesting(enabled: true)
        }

        Test {
            $0.default(project: "TestApp", scheme: "TestApp")
            $0.testsWithoutBuilding(enabled: true)
            $0.destination(Destination(
                platform: Destination.Platform.iOSSimulator,
                name: Destination.Name.iPhoneXr,
                os: Destination.OS.os12_2
            ))
        }
//        SetVersionNumber(options: .init(buildNumber: "1.1"))
//        SetBuildNumber(options: .init(buildNumber: "2"))
//
//        Build(options: .init(
//            buildOptions: xcodebuildOptions,
//            buildsForTesting: true)
//        )
//
//        Test(options: .init(
//            buildOptions: xcodebuildOptions,
//            destination: Destination(
//                platform: Destination.Platform.iOSSimulator,
//                name: Destination.Name.iPhoneXr,
//                os: Destination.OS.os12_2
//            )
//        ))
//
//        Archive(options: .init(
//            buildOptions: xcodebuildOptions,
//            archivePath: recommendedArchiveOptions.archivePath
//        ))
//
//        ExportArchive(
//            options: .init(
//                exportOptionsPlist: nil,
//                archivePath: recommendedArchiveOptions.archivePath,
//                exportPath: recommendedArchiveOptions.exportPath
//            ),
//            exportPlist: .init(
//                teamId: "T78DK947F2",
//                method: ExportMethod.development
//            )
//        )
    }
}

testDrive()
