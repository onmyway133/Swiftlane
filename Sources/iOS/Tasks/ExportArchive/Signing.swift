//
//  Signing.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public enum Signing {
    case manual(ManualSigning)
    case automatic(AutomaticSigning)
}

public struct ManualSigning {
    public struct ProvisioningProfile {
        let bundleId: String
        let nameOrUuid: String

        public init(bundleId: String, nameOrUuid: String) {
            self.bundleId = bundleId
            self.nameOrUuid = nameOrUuid
        }
    }

    // The Developer Portal team to use for this export.
    /// Defaults to the team used to build the archive.
    public let teamId: String

    /// For manual signing only.
    /// Specify the provisioning profile to use for each executable in your app.
    /// Keys in this dictionary are the bundle identifiers of executables; values are the provisioning profile name or UUID to use.
    public let provisioningProfiles: [ProvisioningProfile]


    /// For manual signing only.
    /// Provide a certificate name, SHA-1 hash, or automatic selector to use for signing.
    /// Automatic selectors allow Xcode to pick the newest installed certificate of a particular type.
    /// The available automatic selectors
    /// are "Mac App Distribution", "iOS Developer", "iOS Distribution", "Developer ID Application", "Apple Distribution",
    /// "Mac Developer", and "Apple Development".
    /// Defaults to an automatic certificate selector matching the current distribution method.
    public let certificate: String

    public init(teamId: String, certificate: String, provisioningProfiles: [ProvisioningProfile]) {
        self.teamId = teamId
        self.certificate = certificate
        self.provisioningProfiles = provisioningProfiles
    }
}

public struct AutomaticSigning {
    /// The Developer Portal team to use for this export.
    /// Defaults to the team used to build the archive.
    public let teamId: String

    public init(teamId: String) {
        self.teamId = teamId
    }
}
