//
//  Workflow.swift
//  Colorizer
//
//  Created by khoa on 01/12/2019.
//

import Foundation

/// Workflow is a group of tasks
public class Workflow {
    public let tasks:  [Task]

    public init(tasks: [Task]) {
        self.tasks = tasks
    }

    public func run() {
        let beforeSummarizer = BeforeSummarizer()
        beforeSummarizer.on(tasks: tasks)

        let afterSummarizer = AfterSummerizer()

        do {
            try tasks.forEach({ task in
                Deps.console.task(task.name)

                afterSummarizer.beforeRun(name: task.name)
                try task.run()
                afterSummarizer.afterRun()

                Deps.console.newLine()
            })
        } catch {
            afterSummarizer.afterRun()
            handle(error: error)
        }

        Deps.console.newLine()
        afterSummarizer.show()
    }

    public func handle(error: Error) {
        guard let pumaError = error as? PumaError else {
            Deps.console.error(error.localizedDescription)
            return
        }

        switch pumaError {
        case .process(let terminationStatus, let output, let error):
            let _ = output
            Deps.console.error("code \(terminationStatus)")
            Deps.console.error(error)
        default:
            Deps.console.error(error.localizedDescription)
        }
    }
}
