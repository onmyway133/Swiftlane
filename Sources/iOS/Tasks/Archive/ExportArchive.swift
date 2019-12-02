//
//  ExportArchive.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import Files
import PumaCore

public struct ExportArchive {
    public let options: Options
    public let exportPlist: ExportPlist
    
    public init(options: Options, exportPlist: ExportPlist) {
        self.options = options
        self.exportPlist = exportPlist
    }
}

extension ExportArchive: Task {
    public var name: String {
        return "Export archive to ipa"
    }
    
    public func run() throws {
        let command = "xcodebuild \(toString(arguments: toArguments()))"
        Log.command(command)
        try makeExportPlistIfAny()
        _ = try Process().run(command: command)
    }
}

public extension ExportArchive {
    struct Options {
        /// specifies a path to a plist file that configures archive exporting
        public let exportOptionsPlist: String?
        
        /// specifies the directory where any created archives will be placed,
        /// or the archive that should be exported
        public let archivePath: String
        
        /// specifies the destination for the product exported from an archive
        public let exportPath: String?
        
        public init(exportOptionsPlist: String? = nil, archivePath: String, exportPath: String) {
            self.exportPath = exportPath
            self.archivePath = archivePath
            self.exportOptionsPlist = exportOptionsPlist
        }
    }
    
    struct ExportPlist {
        /// The Developer Portal team to use for this export.
        /// Defaults to the team used to build the archive.
        public let teamId: String
        
        /// Describes how Xcode should export the archive.
        /// Available options: app-store, validation, package, ad-hoc, enterprise, development, developer-id,
        /// and mac-application. The list of options varies based on the type of archive.
        /// Defaults to development.
        public let method: String
        
        public init(teamId: String, method: String = ExportMethod.development) {
            self.teamId = teamId
            self.method = method
        }
    }
}

extension ExportArchive {
    public func makeExportPlistIfAny() throws {
        guard options.exportOptionsPlist == nil else {
            return
        }
        
        let folder = try Folder(path: ".")
        let file = try folder.createFile(named: generatedPlistFileName())
        let content =
"""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>\(exportPlist.method)</string>
    <key>teamID</key>
    <string>\(exportPlist.teamId)</string>
</dict>
</plist>
"""
        try file.write(string: content)
    }
    
    public func generatedPlistFileName() -> String {
        return "ExportOptions.plist"
    }
    
    func toArguments() -> [String?] {
        return [
            "-exportArchive",
            "-archivePath \(options.archivePath.surroundingWithQuotes())",
            options.exportPath.map { "-exportPath \($0.surroundingWithQuotes())" },
            options.exportOptionsPlist.map { "-exportOptionsPlist \($0.addingFileExtension("plist"))" } ?? generatedPlistFileName()
        ]
    }
}
