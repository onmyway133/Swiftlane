//
//  Task.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public typealias TaskCompletion = (Result<(), Error>) -> Void

public protocol Task: AnyObject {
    var name: String { get set }
    var isEnabled: Bool { get set }
    func run(workflow: Workflow, completion: @escaping TaskCompletion)
}

public extension Task {
	func enable(_ isEnabled: Bool) -> Self {
		self.isEnabled = isEnabled
		return self
	}

	func name(_ name: String) -> Self {
		self.name = name
		return self
	}
}
