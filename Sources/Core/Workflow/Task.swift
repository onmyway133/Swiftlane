//
//  Task.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import Combine

public protocol Task: AnyObject {
    var name: String { get }
    func run(workflow: Workflow) throws
}
