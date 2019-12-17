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
        let teamId: String
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
