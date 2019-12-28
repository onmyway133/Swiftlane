//
//  UploadApp.swift
//  PumaiOS
//
//  Created by khoa on 28/12/2019.
//

import Foundation
import PumaCore

public class UploadApp {
    public var name: String = "Upload app"
    public var isEnabled = true
    public var altool = Altool()

    public init(_ closure: (UploadApp) -> Void = { _ in }) {
        closure(self)
    }
}

extension UploadApp: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            try altool.run(workflow: workflow)
        }
    }
}

public extension UploadApp {
    /// For password, go to https://appleid.apple.com/account/manage
    /// to generate app specific password
    func authenticate(username: String, password: String) {
        altool.arguments.append(contentsOf: [
            "--username", username.surroundingWithQuotes(),
            "--password", password.surroundingWithQuotes()
        ])
    }

    /// Specify the platform of the file
    /// osx | ios | appletvos
    func upload(ipaPath: String, fileType: String = "ios") {
        altool.arguments.append(contentsOf: [
            "--upload-app",
            "--file", ipaPath.surroundingWithQuotes(),
            "--type", fileType
        ])
    }
}
