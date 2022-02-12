//
//  Slack.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct Slack {
    public struct Credential {
        let token: String

        public init(token: String) {
            self.token = token
        }
    }

    let credential: Credential

    public init(credential: Credential) {
        self.credential = credential
    }
}

public extension Slack {
    struct Message {
        let channel: String
        let text: String
        let username: String?
        let additionalParameters: [String: String]

        public init(
            channel: String,
            text: String,
            username: String?,
            additionalParameters: [String: String] = [:]
        ) {
            self.channel = channel
            self.text = text
            self.username = username
            self.additionalParameters = additionalParameters
        }
    }

    private struct SendMessageResponse: Decodable {
        let ok: Bool
        let error: String?
    }

    func send(message: Message) async throws {
        let baseUrl = URL(string: "https://slack.com/api/chat.postMessage")!

        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "token", value: credential.token),
            URLQueryItem(name: "channel", value: message.channel),
            URLQueryItem(name: "text", value: message.text),
            URLQueryItem(name: "pretty", value: "1")
        ]

        message.additionalParameters.forEach {
            components?.queryItems?.append(
                URLQueryItem(name: $0, value: $1)
            )
        }

        if let username = message.username {
            components?.queryItems?.append(
                URLQueryItem(name: "username", value: username)
            )
        }

        guard let requestUrl = components?.url else {
            throw SwiftlaneError.invalid("url")
        }

        var request = URLRequest(url: requestUrl)
        request.allHTTPHeaderFields = [
            "Accept": "application/json"
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        _ = try JSONDecoder().decode(SendMessageResponse.self, from: data)
    }
}
