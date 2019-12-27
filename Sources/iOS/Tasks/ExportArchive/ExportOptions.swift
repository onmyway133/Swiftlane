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
        let signing: Signing
        let method: String

        public init(method: String, signing: Signing) {
            self.signing = signing
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
