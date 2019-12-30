//
//  ExportOptions.swift
//  Puma
//
//  Created by khoa on 17/12/2019.
//

import PumaCore

public extension ExportArchive {
    enum OptionsPlist {
        case plistPath(String)
        case options(ExportOptions)
    }

    struct ExportOptions {
        /// The signing style to use when re-signing the app for distribution.
        /// Options are manual or automatic.
        /// Apps that were automatically signed when archived can be signed manually
        /// or automatically during distribution, and default to automatic.
        /// Apps that were manually signed when archived must be manually signed during distribtion,
        /// so the value of signingStyle is ignored.
        let signing: Signing

        /// Describes how Xcode should export the archive.
        /// Available options: app-store, validation, ad-hoc, package, enterprise, development, developer-id, and mac-application.
        /// The list of options varies based on the type of archive.
        /// Defaults to development.
        let method: String

        /// Allow adding more options in form of xml
        let additionalParameters: [String: Any]

        public init(method: String, signing: Signing, additionalParameters: [String: Any] = [:]) {
            self.signing = signing
            self.method = method
            self.additionalParameters = additionalParameters
        }
    }

    struct ExportMethod {
        public static let appStore = "app-store"
        public static let inHouse = "enterprise"
        public static let adHoc = "ad-hoc"
        public static let development = "development"
    }
}
