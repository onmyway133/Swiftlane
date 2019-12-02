//
//  IncreaseBuildNumberTask.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation
import PumaCore

public class IncreaseBuildNumber: UsesCommandLine {
    public var program: String { "agvtool" }
    public var arguments = Set<String>()

    public init(_ closure: (IncreaseBuildNumber) -> Void) {
        closure(self)
    }
}

extension IncreaseBuildNumber: Task {
    public var name: String { "Increase build number" }
}

public extension IncreaseBuildNumber {
    func nextVersionForAllTargets() {
        arguments.insert("next-version")
        arguments.insert("-all")
    }
}
