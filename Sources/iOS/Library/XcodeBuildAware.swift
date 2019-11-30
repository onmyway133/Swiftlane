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
    func project(project: String, scheme: String)
    func project(_ name: String)
    func scheme(_ name: String)
    func workspace(_ name: String)
    func configuration(_ configuration: String)
    func sdk(_ sdk: String)
    func usesModernBuildSystem(enabled: Bool)
}

public extension XcodeBuildAware {
    var command: String { "xcodebuild" }

    func `default`(project: String, scheme: String) {
        self.project(project)
        self.scheme(scheme)
        self.configuration(Configuration.debug)
        self.sdk(Sdk.iPhoneSimulator)
        self.usesModernBuildSystem(enabled: true)
    }

    func project(_ name: String) {
        arguments.insert("-project \(name.addingFileExtension("xcodeproj"))")
    }

    func workspace(_ name: String) {
        arguments.insert("-workspace \(name.addingFileExtension("xcworkspace"))")
    }

    func scheme(_ name: String) {
        arguments.insert("-scheme \(name)")
    }

    func configuration(_ configuration: String) {
        arguments.insert("-configuration \(configuration)")
    }

    func sdk(_ sdk: String) {
        arguments.insert("-sdk \(sdk)")
    }

    func usesModernBuildSystem(enabled: Bool) {
        arguments.insert("-UseModernBuildSystem=\(enabled ? "YES": "NO")")
    }
}
