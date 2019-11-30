//
//  Task.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public protocol Task {
    var name: String { get }
    func run() throws
}
