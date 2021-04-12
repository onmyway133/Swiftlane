//
//  DownloadMetadata.swift
//  Puma
//
//  Created by khoa on 01/01/2020.
//

import Foundation
import PumaCore

public class DownloadMetadata {
    public var name: String = "Download app metadata from AppStore Connect"
    public var isEnabled = true

	private var transporter = Transporter()

    private let appSKU: String
    private let saveDirectory: String

	public init(appSKU: String, saveDirectory: String = ".") {
		self.appSKU = appSKU
		self.saveDirectory = saveDirectory
    }
}

// MARK: - Modifiers

public extension DownloadMetadata {
	func username(_ username: String) -> Self {
		transporter.arguments.append(contentsOf: ["-u", username.surroundingWithQuotes()])
		return self
	}

	/// For password, go to https://appleid.apple.com/account/manage
	/// to generate app specific password
	func password(_ appSpecificPassword: String) -> Self {
		transporter.arguments.append(contentsOf: ["-p", appSpecificPassword.surroundingWithQuotes()])
		return self
	}
}

// MARK: - Task

extension DownloadMetadata: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            transporter.arguments.append(contentsOf: [
                "-m", "lookupMetadata",
                "-vendor_id", appSKU,
                "-destination", saveDirectory
            ])

            try transporter.run(workflow: workflow)
        }
    }
}
