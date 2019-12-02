//
//  Test.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore

public class Test: UsesXcodeBuild {
    public var arguments = Set<String>()

    public init(_ closure: (Test) -> Void) {
        closure(self)
    }
}

extension Test: Task {
    public var name: String { "Test" }

    public func run() throws {
        arguments.insert("test")
        try (self as UsesCommandLine).run()
    }
}

public extension Test {
    func destination(_ destination: Destination) {
        arguments.insert("-destination \(destination.toString())")
    }

    func testsWithoutBuilding(enabled: Bool) {
        if enabled {
            arguments.insert("test-without-building")
        } else {
            arguments.remove("test-without-building")
        }
    }
}
