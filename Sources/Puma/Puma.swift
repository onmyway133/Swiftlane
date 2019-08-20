//
//  Puma.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

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
                Log.task(task.name)
                try task.validate()
                
                afterSummarizer.beforeRun(name: task.name)
                try task.run()
                afterSummarizer.afterRun()
                
                Log.newLine()
            })
        } catch {
            afterSummarizer.afterRun()
            handle(error: error)
        }
        
        Log.newLine()
        afterSummarizer.show()
    }
    
    public func handle(error: Error) {
        guard let pumaError = error as? PumaError else {
            Log.error(error.localizedDescription)
            return
        }
        
        switch pumaError {
        case .process(let terminationStatus, let output, let error):
            let _ = output
            Log.error("code \(terminationStatus)")
            Log.error(error)
        default:
            Log.error(error.localizedDescription)
        }
    }
}
