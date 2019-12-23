//
//  Summarizer.swift
//  PumaCore
//
//  Created by khoa on 23/12/2019.
//

import Foundation

public class Summarizer {
    public class Record {
        public let task: Task
        public var startTime: Date?
        public var finishTime: Date?
        public var error: Error?

        public init(task: Task) {
            self.task = task
        }
    }

    public var records = [Record]()

    public func update(tasks: [Task]) {
        self.records = tasks.map({
            Record(task: $0)
        })
    }

    public func showTasks() {
        Deps.console.header("Tasks to run")
        records.enumerated().forEach({ index, record in
            Deps.console.text("  \(index + 1). \(record.task.name)")
        })

        Deps.console.newLine()
    }
}
