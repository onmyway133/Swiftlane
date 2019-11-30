//
//  Signing.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public enum Signing {
    case manual(ManualSigning)
    case auto(AutomaticSigning)
    
    public func toArguments() -> [String: String?] {
        switch self {
        case .manual(let signing): return signing.toArguments()
        case .auto(let signing): return signing.toArguments()
        }
    }
}

public struct ManualSigning {
    public init() {}
    public func toArguments() -> [String: String?] {
        return [:]
    }
}

public struct AutomaticSigning {
    public let teamId: String
    
    public init(teamId: String) {
        self.teamId = teamId
    }
    
    public func toArguments() -> [String: String?] {
        return [
            "DEVELOPMENT_TEAM=": teamId
        ]
    }
}
