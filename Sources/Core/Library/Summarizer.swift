//
//  Summarizer.swift
//  PumaCore
//
//  Created by khoa on 23/12/2019.
//

import Foundation
import CLISpinner

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
    public let logger: Logger

    public init(logger: Logger) {
        self.logger = logger
    }

    public func update(tasks: [Task]) {
        let accumulatedTasks: [Task] = tasks.flatMap({ accumulateTasks(in: $0) })
        self.records = accumulatedTasks.map({
            Record(task: $0)
        })
    }

    public func showTasks() {
        logger.logo()
//        logger.puma()
        loadTasksWithAnimation()
        logger.header("Tasks to run")
        records.enumerated().forEach({ index, record in
            let symbol = record.task.isEnabled ? "✅" : "☑️"
            let num = index < 9 ? "  \(index + 1)" : " \(index + 1)"
            let text = " \(num). \(symbol) \(record.task.name)"
            logger.text(text)
        })

        logger.newLine()
    }
    
    private func loadTasksWithAnimation() {
        logger.newLines(2)
        let s = Spinner(pattern: .dots, text: "Loading the tasks...", color: .lightCyan)
        s.start()
        sleep(2)
        s.succeed(text: "Tasks loaded")
    }

    public func showSummary() {
        logger.header("Summary")

        records.enumerated().forEach { index, record in
            var duration: TimeInterval = 0
            let symbol: String

            if let startAt = record.startAt, let finishAt = record.finishAt {
                duration = finishAt.timeIntervalSince1970 - startAt.timeIntervalSince1970
                if record.error != nil {
                    symbol = "❌"
                } else {
                    symbol = "✅"
                }
            } else {
                 symbol = "☑️"
            }

            let timeString = parse(seconds: duration)
            let num = index < 9 ? "  \(index + 1)" : " \(index + 1)"
            logger.text(" \(num). \(symbol) \(record.task.name) (\(timeString))")
        }

        logger.newLine()
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

    private func accumulateTasks(in task: Task) -> [Task]  {
        if let sequence = task as? Sequence {
            return sequence.tasks.flatMap({ accumulateTasks(in: $0) })
        } else if let concurrent = task as? Concurrent {
            return concurrent.tasks.flatMap({ accumulateTasks(in: $0) })
        } else {
            return [task]
        }
    }

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
