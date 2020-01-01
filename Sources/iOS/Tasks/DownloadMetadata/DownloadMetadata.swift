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
    public var transporter = Transporter()

    private var appSKU: String?
    private var saveDirectory: String?

    public init(_ closure: (DownloadMetadata) -> Void = { _ in }) {
        closure(self)
    }
}

extension DownloadMetadata: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            guard let appSKU = appSKU, let saveDirectory = saveDirectory else {
                throw PumaError.invalid
            }

            transporter.arguments.append(contentsOf: [
                "-vendor_id", appSKU,
                "-destination", saveDirectory
            ])


            try transporter.run(workflow: workflow)
        }
    }
}

public extension DownloadMetadata {
    /// For password, go to https://appleid.apple.com/account/manage
    /// to generate app specific password
    func authenticate(username: String, appSpecificPassword: String) {
        transporter.arguments.append(contentsOf: [
            "--username", username.surroundingWithQuotes(),
            "--password", appSpecificPassword.surroundingWithQuotes()
        ])
    }

    // Download app metadata
    func download(appSKU: String, saveDirectory: String) {
        self.appSKU = appSKU
        self.saveDirectory = saveDirectory
    }
}
