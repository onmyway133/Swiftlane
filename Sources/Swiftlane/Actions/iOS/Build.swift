//
//  Build.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public final class Build {
    public var args = Args()

    public init() {}

    public func run() async throws {

    }
}

extension Build: UseXcodebuild {}
