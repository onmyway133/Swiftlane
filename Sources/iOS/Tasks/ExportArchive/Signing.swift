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
    public let teamId: String
    public let bundleId: String
    public let certificate: String

    public init(teamId: String, bundleId: String, certificate: String) {
        self.teamId = teamId
        self.bundleId = bundleId
        self.certificate = certificate
    }
}

public struct AutomaticSigning {
    public let teamId: String

    public init(teamId: String) {
        self.teamId = teamId
    }
}
