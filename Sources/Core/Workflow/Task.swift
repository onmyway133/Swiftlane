//
//  Task.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public protocol Task: AnyObject {
    var name: String { get }
    var workflow: Workflow? { get set }
    func run() throws
}
