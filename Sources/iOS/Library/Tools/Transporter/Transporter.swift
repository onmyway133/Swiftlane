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
            program: "/Applications/Transporter.app/Contents/itms/bin/iTMSTransporter",
            arguments: arguments
        )
    }
}

