//
//  XcodeBuildAware.swift
//  PumaiOS
//
//  Created by khoa on 30/11/2019.
//

import Foundation
import PumaCore

/// Any task that uses xcodebuild
public protocol XcodeBuildAware: CommandLineAware {
    func project(_ projectName: String, scheme: String)
    func project(_ name: String)
    func scheme(_ name: String)
    func workspace(_ name: String)
    func configuration()
}

public extension XcodeBuildAware {
    var command: String { "xcodebuild" }

    func project(_ name: String) {
        arguments.insert("-project \(name.addingFileExtension("xcodeproj"))")
    }

    func workspace(_ name: String) {
        arguments.insert("-workspace \(name.addingFileExtension("xcworkspace"))")
    }

    func scheme(_ name: String) {
        arguments.insert("-scheme \(name)")
    }

    func project(_ projectName: String, scheme: String) {
        self.project(projectName)
        self.scheme(scheme)
    }
}
