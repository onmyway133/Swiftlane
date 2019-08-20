//
//  Task.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public protocol Task {
    var name: String { get }
    func validate() throws
    func run() throws
}

public extension Task {
    func validate() throws {}
}

public extension Task {
    func toString(arguments: [String?]) -> String {
        return arguments
            .compactMap({ $0 })
            .joined(separator: " ")
    }
}
