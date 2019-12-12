//
//  TaskBuiler.swift
//  Puma
//
//  Created by khoa on 18/08/2019.
//

import Foundation

@_functionBuilder
public struct TaskBuilder {
    public static func buildBlock(_ tasks: Task...) -> [Task] {
        tasks
    }
}
