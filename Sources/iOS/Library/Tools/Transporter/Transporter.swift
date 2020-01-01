//
//  Transporter.swift
//  Puma
//
//  Created by khoa on 01/01/2020.
//

import Foundation
import PumaCore
import Files

public struct Transporter {
    var arguments: [String] = []

    func run(workflow: Workflow) throws {
        guard Folder.directoryExists(path: "/Applications/Transporter.app") else {
            Deps.console.warn("You need to install Transporter")
            throw PumaError.invalid
        }

        try CommandLine().runBash(
            workflow: workflow,
            program: transportPath(),
            arguments: arguments,
            processHandler: DefaultProcessHandler(filter: { !$0.contains("DBG-X:") && !$0.contains("DEBUG:") })
        )
    }

    private func transportPath() throws -> String {
        if Folder.directoryExists(path: "/Applications/Transporter.app") {
            return "/Applications/Transporter.app/Contents/itms/bin/iTMSTransporter"
        } else if Folder.directoryExists(path: "/Applications/Xcode.app/Contents/Applications/Application Loader.app/") {
            return "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/MacOS/itms/bin/iTMSTransporter"
        } else {
            throw PumaError.invalid
        }
    }
}

