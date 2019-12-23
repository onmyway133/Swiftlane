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
        public var startAt: Date?
        public var finishAt: Date?
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

    public func showSummary() {
        Deps.console.header("Summary")

        records.enumerated().forEach { index, record in
            var duration: TimeInterval = 0
            var symbol: String = "☑️"

            if let startAt = record.startAt, let finishAt = record.finishAt {
                duration = finishAt.timeIntervalSince1970 - startAt.timeIntervalSince1970
                symbol = "✅"
            } else if record.error != nil {
                symbol = "❌"
            }

            let timeString = parse(seconds: duration)
            Deps.console.text("  \(index + 1). \(symbol) \(record.task.name) (\(timeString))")
        }

        Deps.console.newLine()
    }

    // MARK: - Track

    public func track(task: Task, startAt: Date) {
        findRecord(task: task)?.startAt = startAt
    }

    public func track(task: Task, finishAt: Date) {
        findRecord(task: task)?.finishAt = finishAt
    }

    public func track(task: Task, error: Error) {
        findRecord(task: task)?.error = error
    }

    //  MARK: - Private

    func findRecord(task: Task) -> Record? {
        return records.first(where: { $0.task === task })
    }

    private func parse(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: seconds) ?? "0s"
    }
}
