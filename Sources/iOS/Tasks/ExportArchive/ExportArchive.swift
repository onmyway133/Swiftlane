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

    private var optionsPlist: OptionsPlist

    public init(options: OptionsPlist = .plistPath("")) {
        optionsPlist = options
    }
}

// MARK: - Modifiers

public extension ExportArchive {
    func projectType(_ projectType: ProjectType, archivePath path: String) -> Self {
        xcodebuild.projectType(projectType)
        xcodebuild.archivePath(path, name: projectType.name)
        return self
    }

    func exportPath(_ exportPath: String) -> Self {
        xcodebuild.exportPath(exportPath)
        return self
    }
}

// MARK: - Task

extension ExportArchive: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            try applyOptionsPlist()
            xcodebuild.arguments.append("-exportArchive")

            switch optionsPlist {
            case .options(let options):
                switch options.signing {
                case .automatic:
                    xcodebuild.arguments.append("-allowProvisioningUpdates")
                default:
                    break
                }
            default:
                break
            }

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
            .createSubfolderIfNeeded(withName: "Puma")
            .createFile(named: "\(UUID().uuidString).plist")

        let generator = XmlGenerator()
        let xml = generator.generateXml(self.items(from: options))
        try file.write(string: xml)
        return file.path
    }

    func items(from options: ExportArchive.ExportOptions) -> [XmlItem] {
        var items = [XmlItem]()

        items.append(XmlString(key: "method", value: options.method))

        switch options.signing {
        case .manual(let manualSigning):
            items.append(contentsOf: [
                XmlString(key: "signingStyle", value: "manual"),
                XmlString(key: "teamID", value: manualSigning.teamId),
                XmlString(key: "signingCertificate", value: manualSigning.certificate)
            ])

            items.append(
                XmlDict(
                    key: "provisioningProfiles",
                    items: manualSigning.provisioningProfiles.map({ profile in
                        XmlString(key: profile.bundleId, value: profile.nameOrUuid)
                    })
                )
            )
        case .automatic(let automaticSigning):
            items.append(contentsOf: [
                XmlString(key: "signingStyle", value: "automatic"),
                XmlString(key: "teamID", value: automaticSigning.teamId)
            ])
        }

        let generator = XmlGenerator()
        items.append(contentsOf: generator.xmlItems(dictionary: options.additionalParameters))
        return items
    }
}
