//
//  AppStoreConnect.swift
//  Swiftlane
//
//  Created by khoa on 12/02/2022.
//

import AppStoreConnect_Swift_SDK

public struct AppStoreConnect {
    public let provider: APIProvider

    public init(configuration: APIConfiguration) {
        provider = APIProvider(configuration: configuration)
    }
}
