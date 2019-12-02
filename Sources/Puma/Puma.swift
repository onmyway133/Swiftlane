//
//  Puma.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation
import PumaCore

public func run(@TaskBuilder builder: () -> [Task]) {
    let workflow = Workflow(name: "Default workflow", builder: builder)
    workflow.run(completion: { _ in })
}

public func run(@TaskBuilder builder: () -> Task) {
    let workflow = Workflow(name: "Default workflow", builder: builder)
    workflow.run(completion: { _ in })
}
