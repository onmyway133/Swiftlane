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
    public var name: String = "Export archive"
    public var isEnabled = true
    public var xcodebuild = Xcodebuild()

    private var optionsPlist: OptionsPlist = .plistPath("")

    public init(_ closure: (ExportArchive) -> Void = { _ in }) {
        closure(self)
    }
}

extension ExportArchive: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            try applyOptionsPlist()
            xcodebuild.arguments.append("-exportArchive")
            try xcodebuild.run(workflow: workflow)
        }
    }
}

public extension ExportArchive {
    func configure(
        projectType: ProjectType,
        archivePath: String,
        optionsPlist: OptionsPlist,
        exportDirectory: String
    ) {
        self.optionsPlist = optionsPlist

        xcodebuild.projectType(projectType)
        xcodebuild.exportPath(exportDirectory)
        xcodebuild.archivePath(archivePath, name: projectType.name)
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
            .createSubfolderIfNeeded(withName: "Puma")
            .createFile(named: "\(UUID().uuidString).plist")

        let generator = PlistGenerator()
        let records = generator.records(from: options)
        let xml = generator.generateXml(records)
        try file.write(string: xml)
        return file.path}
}

class PlistGenerator {
    struct Record {
        let key: String
        let value: String
        let type: String

        func toLines() -> [String] {
            return [
                "<key>\(key)</key>",
                "<\(type)>\(value)</\(type)>"
            ] as [String]
        }
    }

    func records(from options: ExportArchive.ExportOptions) -> [Record] {
        var records = [Record]()

        records.append(Record(key: "method", value: options.method, type: "string"))

        switch options.signing {
        case .manual(let manualSigning):
            records.append(contentsOf: [
                Record(key: "signingStyle", value: "automatic", type: "string"),
                Record(key: "teamID", value: manualSigning.teamId, type: "string"),
                Record(key: "signingCertificate", value: manualSigning.certificate, type: "string")
            ])

            manualSigning.provisioningProfiles.forEach { profile in
                records.append(Record(key: profile.bundleId, value: profile.nameOrUuid, type: "string"))
            }
        case .automatic(let automaticSigning):
            records.append(contentsOf: [
                Record(key: "signingStyle", value: "manual", type: "string"),
                Record(key: "teamID", value: automaticSigning.teamId, type: "string")
            ])
        }

        return records
    }

    func generateXml(_ records: [Record]) -> String {
        let content = records.flatMap({ $0.toLines() }).joined(separator: "\n")
        let xml =
"""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    \(content)
</dict>
</plist>
"""
        return xml
    }
}
