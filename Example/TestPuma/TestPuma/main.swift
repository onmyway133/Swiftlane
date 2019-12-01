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
        WorkingDirectory()

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
    }

    workflow.workingDirectory = "/Users/khoa/XcodeProject2/Puma/Example/TestApp"
    workflow.run()
}

testDrive()
