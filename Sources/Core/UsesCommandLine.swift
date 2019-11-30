//
//  CommandLineAware.swift
//  PumaCore
//
//  Created by khoa on 30/11/2019.
//

import Foundation

/// Any task that uses command line
public protocol UsesCommandLine: AnyObject {
    var program: String { get }
    var arguments: Set<String> { get set }
}

public extension UsesCommandLine {
    func run() throws {
        let command = "\(program) \(arguments.joined(separator: " "))"
        Log.command(command)
        _ = try Process().run(command: command)
    }
}
