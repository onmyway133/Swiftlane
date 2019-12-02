//
//  Summarizer.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public class AfterSummerizer {
    public struct Entry {
        var name: String = ""
        var startDate = Date()
        var endDate = Date()
        
        var duration: TimeInterval {
            return endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        }
    }
    
    public var entries: [Entry] = []
    public var currentEntry = Entry()
    
    public init() {}
    
    public func beforeRun(name: String) {
        currentEntry = Entry()
        currentEntry.name = name
        currentEntry.startDate = Date()
    }
    
    public func afterRun() {
        currentEntry.endDate = Date()
        entries.append(currentEntry)
    }
    
    public func show() {
        Deps.console.title("Summary")

        entries.enumerated().forEach({ tuple in
            let timeString = parse(seconds: tuple.element.duration)
            Deps.console.text("  \(tuple.offset + 1). \(tuple.element.name) (\(timeString))")
        })
        
        Deps.console.newLine()
    }
    
    public func parse(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: seconds) ?? "0s"
    }
}
