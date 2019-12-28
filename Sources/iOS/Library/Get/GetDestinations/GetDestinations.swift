//
//  GetDestinations.swift
//  PumaiOS
//
//  Created by khoa on 20/12/2019.
//

import PumaCore
import Foundation

public class GetDestinations {
    public init() {}

    public func getAvailable(workflow: Workflow) throws -> [Destination] {
        let processHandler = DefaultProcessHandler(filter: { $0.starts(with: "name=") })
        let string = try CommandLine().runBash(
            workflow: workflow,
            program: "xcrun simctl",
            arguments: [
                "list",
                "devices",
                "-j"
            ],
            processHandler: processHandler
        )

        guard let data = string.data(using: .utf8) else {
            throw PumaError.invalid
        }

        let response: Response = try JSONDecoder().decode(Response.self, from: data)
        let devicesWithOS: [DeviceWithOS] = response.devices.flatMap({ key, value in
            return value.map({ DeviceWithOS(device: $0, os: key) })
        })

        let destinations: [Destination] = try devicesWithOS
            .filter({ withOS in
                return withOS.device.isAvailable
            })
            .compactMap({ withOS in
                guard
                    let platform = self.platform(withOS: withOS),
                    let os = try self.os(withOS: withOS)
                else {
                    return  nil
                }

                var destination = Destination(
                    name: withOS.device.name,
                    platform: platform,
                    os: os
                )
                destination.id = withOS.device.uuid
                return destination
            })

        return destinations
    }

    func findId(workflow: Workflow, destination: Destination) throws -> String? {
        let availableDestinations = try self.getAvailable(workflow: workflow)
        return availableDestinations.first(where: { $0 == destination })?.id
    }

    // MARK: - Private

    private func platform(withOS: DeviceWithOS) -> String? {
        let list: [String] = [
            Destination.Platform.iOS,
            Destination.Platform.watchOS,
            Destination.Platform.macOS,
            Destination.Platform.tvOS,
        ]

        return list.first(where: { withOS.os.contains($0) })
    }

    // com.apple.CoreSimulator.SimRuntime.iOS-13-2
    private func os(withOS: DeviceWithOS) throws -> String? {
        return try withOS.os.matches(pattern: #"(-\d+)+"#).first
    }
}

private struct Response: Decodable {
    let devices: [String: [Device]]
}

private struct Device: Decodable {
    let state: String
    let name: String
    let uuid: String
    let isAvailable: Bool
}

private struct DeviceWithOS {
    let device: Device
    let os: String
}
