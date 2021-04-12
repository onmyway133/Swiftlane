//
//  UploadApp.swift
//  PumaiOS
//
//  Created by khoa on 28/12/2019.
//

import Foundation
import PumaCore

public class UploadApp {
    public var name: String = "Upload app to AppStore Connect"
    public var isEnabled = true

	private var altool = Altool()

	private var arguments: [String: String]

	/// Specify the location and platform of the file
	/// osx | ios | appletvos
    public init(path: String, fileType: String = FileType.ios) {
		arguments = [
			"--file": path.surroundingWithQuotes(),
			"--type": fileType
		]
    }
}

// MARK: - Modifiers

public extension UploadApp {
	struct FileType {
		public static let ios = "ios"
		public static let osx = "osx"
		public static let iappletvosos = "appletvos"
	}

	func username(_ username: String) -> Self {
		arguments["--username"] = username.surroundingWithQuotes()
		return self
	}

	/// For password, go to https://appleid.apple.com/account/manage
	/// to generate app specific password
	func password(_ appSpecificPassword: String) -> Self {
		arguments["--password"] = appSpecificPassword.surroundingWithQuotes()
		return self
	}
}

// MARK: - Task

extension UploadApp: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
		arguments.forEach { (key, value) in
			altool.arguments.append(contentsOf: [key, value])
		}

        handleTryCatch(completion) {
            try altool.run(workflow: workflow)
        }
    }
}
