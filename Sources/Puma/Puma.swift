//
//  Puma.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation
import PumaCore

public func run(@TaskBuilder builder: () -> [Task]) {
    Workflow().run(tasks: builder())
}

public func run(@TaskBuilder builder: () -> Task) {
    Workflow().run(tasks: [builder()])
}

public struct Workflow {
    public init() {}

    public func run(tasks: [Task]) {
        let beforeSummarizer = BeforeSummarizer()
        beforeSummarizer.on(tasks: tasks)
        
        let afterSummarizer = AfterSummerizer()
        
        do {
            try tasks.forEach({ task in
                Deps.console.title(task.name)
                
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
