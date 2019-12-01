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
    var arguments: [String] { get set }
}

public extension UsesCommandLine {
    func run() throws {
        let joinedArguments = arguments.joined(separator: " ")
        let command = "\(program) \(joinedArguments)"
        Deps.console.command(command)

        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]
        
        try process.run()
    }
}
