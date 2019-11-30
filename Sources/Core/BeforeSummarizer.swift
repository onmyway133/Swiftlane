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
        Log.beforeSummary("Tasks to run")
        tasks.enumerated().forEach({ tuple in
            Log.plain("  \(tuple.offset + 1). \(tuple.element.name)")
        })
        
        Log.newLine()
    }
}
