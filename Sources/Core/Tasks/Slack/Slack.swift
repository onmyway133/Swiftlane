//
//  Slack.swift
//  PumaCore
//
//  Created by khoa on 30/12/2019.
//

import Foundation

public class Slack {
    public var name: String = "Send message to Slack"
    public var isEnabled = true

    private var message: Message?

    public init(_ closure: (Slack) -> Void = { _ in }) {
        closure(self)
    }
}

public extension Slack {
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

    func post(message: Message) {
        self.message = message
    }
}

extension Slack: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        guard let message = message else {
            completion(.failure(PumaError.invalid))
            return
        }

        let sender = MessageSender()
        sender.send(message: message, completion: { result in
            switch result {
            case .success:
                workflow.logger.success("Posted: \(message.text)")
            case .failure(let error):
                workflow.logger.error("Failed: \(error.localizedDescription)")
            }
            completion(result)
        })
    }
}

private class MessageSender {
    struct Response: Decodable {
        let ok: Bool
        let error: String?
    }

    func send(message: Slack.Message, completion: @escaping (Result<(), Error>) -> Void) {
        guard let baseUrl = URL(string: "https://slack.com/api/chat.postMessage") else {
            completion(.failure(PumaError.invalid))
            return
        }

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
            completion(.failure(PumaError.invalid))
            return
        }

        var request = URLRequest(url: requestUrl)
        request.allHTTPHeaderFields = [
            "Accept": "application/json"
        ]

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else {
                completion(.failure(error ?? PumaError.invalid))
                return
            }

            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                if response.ok {
                    completion(.success(()))
                } else {
                    completion(.failure(PumaError.from(string: response.error)))
                }
            } catch {
                completion(.failure(error))
            }
        })

        task.resume()
    }
}
