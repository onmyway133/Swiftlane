//
//  ExportArchive.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore
import Files

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
            try applyOptionsPlist()
            xcodebuild.arguments.append("exportArchive")
            try xcodebuild.run(workflow: workflow)
        }
    }
}

private extension ExportArchive {
    func applyOptionsPlist() throws {
        switch optionsPlist {
        case .plistPath(let path):
            xcodebuild.exportOptionsPlist(path)
        case .options(let options):
            let path = try makePlist(options)
            xcodebuild.exportOptionsPlist(path)
        }
    }

    func makePlist(_ options: ExportOptions) throws -> String {
        let file = try Folder.temporary
            .createSubfolder(named: "Puma")
            .createFile(named: "\(UUID().uuidString).plist")

            let content =
"""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>\(options.method)</string>
    <key>teamID</key>
    <string>\(options.teamId)</string>
</dict>
</plist>
"""
            try file.write(string: content)
            return file.path
        }
}

public extension ExportArchive {
    func configure(
        projectType: ProjectType,
        scheme: String,
        archivePath: String,
        optionsPlist: OptionsPlist,
        exportDirectory: String
    ) {
        self.optionsPlist = optionsPlist

        xcodebuild.projectType(projectType)
        xcodebuild.scheme(scheme)
        xcodebuild.exportPath(exportDirectory)
        xcodebuild.archivePath(archivePath, scheme: scheme)
    }
}
