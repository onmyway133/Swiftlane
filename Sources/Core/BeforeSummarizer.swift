//
//  BeforeSummarizer.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct BeforeSummarizer {
    public init() {}
    public func on(tasks: [Task]) {
        Deps.console.title("Tasks to run")
        tasks.enumerated().forEach({ tuple in
            Deps.console.text("  \(tuple.offset + 1). \(tuple.element.name)")
        })
        
        Deps.console.newLine()
    }
}
