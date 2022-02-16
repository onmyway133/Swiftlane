//
//  Env.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct Environment {
    public subscript(_ key: String) -> String? {
        get {
            ProcessInfo.processInfo.environment[key]
        }
    }
}
