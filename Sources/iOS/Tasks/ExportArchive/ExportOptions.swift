//
//  ExportOptions.swift
//  Puma
//
//  Created by khoa on 17/12/2019.
//

import Foundation

public extension ExportArchive {
    enum OptionsPlist {
        case plistPath(String)
        case options(ExportOptions)
    }

    struct ExportOptions {
        /// The Developer Portal team to use for this export.
        /// Defaults to the team used to build the archive.
        let teamId: String
        /// Describes how Xcode should export the archive.
        /// Available options: app-store, validation, package, ad-hoc, enterprise, development, developer-id,
        /// and mac-application. The list of options varies based on the type of archive.
        /// Defaults to development.
        let method: String

        public init(teamId: String, method: String) {
            self.teamId = teamId
            self.method = method
        }
    }

    struct ExportMethod {
        public static let appStore = "app-store"
        public static let inHouse = "enterprise"
        public static let adHoc = "ad-hoc"
        public static let development = "development"
    }
}
