//
//  AppStoreConnect.swift
//  Swiftlane
//
//  Created by khoa on 12/02/2022.
//

import AppStoreConnect

public struct ASC {
    public let client: AppStoreConnect.Client

    public init(credential: AppStoreConnect.Credential) throws {
        self.client = try AppStoreConnect.Client(credential: credential)
    }
}
