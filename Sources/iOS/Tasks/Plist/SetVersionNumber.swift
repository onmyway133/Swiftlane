//
//  SetVersionNumber.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//  Copyright © 2019 onmyway133. All rights reserved.
//

import Foundation
import PumaCore

public class SetVersionNumber: UsesCommandLine {
    public var program: String { "agvtool" }
    public var arguments = Set<String>()

    public init(_ closure: (SetVersionNumber) -> Void) {
        closure(self)
    }
}

extension SetVersionNumber: Task {
    public var name: String { "Set version number" }
}

public extension SetVersionNumber {
    func versionNumberForAllTargets(_ number: String) {
        arguments.insert("new-marketing-version")
        arguments.insert(number)
    }
}

