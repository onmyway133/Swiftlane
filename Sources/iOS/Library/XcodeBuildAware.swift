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
    func project(name projectName: String, scheme: String)
    func project(name: String)
    func scheme(name: String)
    func target(name: String)
    func workspace(name: String)
}

public extension XcodeBuildAware {
    var command: String { "xcodebuild" }

    
}
