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

        let generator = XmlGenerator()
        let xml = generator.generateXml(self.items(from: options))
        try file.write(string: xml)
        return file.path
    }

    func items(from options: ExportArchive.ExportOptions) -> [XmlItem] {
        var items = [XmlItem]()

        items.append(Xml.Record(key: "method", value: options.method, type: "string"))

        switch options.signing {
        case .manual(let manualSigning):
            items.append(contentsOf: [
                Xml.Record(key: "signingStyle", value: "automatic", type: "string"),
                Xml.Record(key: "teamID", value: manualSigning.teamId, type: "string"),
                Xml.Record(key: "signingCertificate", value: manualSigning.certificate, type: "string")
            ])

            items.append(
                Xml.Dict(
                    key: "provisioningProfiles",
                    items: manualSigning.provisioningProfiles.map({ profile in
                        Xml.Record(key: profile.bundleId, value: profile.nameOrUuid, type: "string")
                    })
                )
            )
        case .automatic(let automaticSigning):
            items.append(contentsOf: [
                Xml.Record(key: "signingStyle", value: "manual", type: "string"),
                Xml.Record(key: "teamID", value: automaticSigning.teamId, type: "string")
            ])
        }

        items.append(contentsOf: options.more)
        return items
    }
}
