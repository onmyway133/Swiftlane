//
//  Slack.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct Slack {
    struct Message {
        let token: String
        let channel: String
        let text: String
        let username: String?
        let additionalParameters: [String: String]

        public init(
            token: String,
            channel: String,
            text: String,
            username: String?,
            additionalParameters: [String: String] = [:]
        ) {
            self.token = token
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
            URLQueryItem(name: "token", value: message.token),
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
