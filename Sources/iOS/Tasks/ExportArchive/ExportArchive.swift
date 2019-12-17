//
//  ExportArchive.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore

public class ExportArchive {
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()

    private var optionsPlist: OptionsPlist = .plistPath("")

    public init(_ closure: (ExportArchive) -> Void = { _ in }) {
        closure(self)
    }
}

extension ExportArchive: Task {
    public var name: String { "Export archive to ipa" }

    public func run(workflow: Workflow, completion: TaskCompletion) {
        with(completion) {
            xcodebuild.arguments.append("exportArchive")
            try xcodebuild.run(workflow: workflow)
        }
    }
}

public extension ExportArchive {
    func configure(
        project: String,
        scheme: String,
        archivePath: String,
        optionsPlist: OptionsPlist,
        exportDirectory: String
    ) {
        self.optionsPlist = optionsPlist

        xcodebuild.project(project)
        xcodebuild.scheme(scheme)
        xcodebuild.exportPath(exportDirectory)
        xcodebuild.archivePath(archivePath, scheme: scheme)
    }

    func configure(
        workspace: String,
        scheme: String,
        archivePath: String,
        optionsPlist: OptionsPlist,
        exportDirectory: String
    ) {
        self.optionsPlist = optionsPlist

        xcodebuild.workspace(workspace)
        xcodebuild.scheme(scheme)
        xcodebuild.exportPath(exportDirectory)
        xcodebuild.archivePath(archivePath, scheme: scheme)
    }
}
