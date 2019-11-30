//
//  SetBuildNumber.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 onmyway133. All rights reserved.
//

import Foundation
import PumaCore

public class SetBuildNumber: UsesCommandLine {
    public var program: String { "agvtool" }
    public var arguments = Set<String>()

    public init(_ closure: (SetBuildNumber) -> Void) {
        closure(self)
    }
}

extension SetBuildNumber: Task {
    public var name: String { "Set build number" }
}

public extension SetBuildNumber {
    func buildNumberForAllTarget(_ number: String) {
        arguments.insert("new-version")
        arguments.insert("-all")
        arguments.insert(number)
    }
}
