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
        let string = try CommandLine().runBash(
            workflow: workflow,
            program: "xcrun simctl",
            arguments: [
                "list",
                "devices",
                "-j"
            ],
            processHandler: DefaultProcessHandler(filter: { $0.starts(with: "name=") })
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

                return Destination(
                    name: withOS.device.name,
                    platform: platform,
                    os: os,
                    udid: withOS.device.udid
                )
            })

        return destinations
    }

    func findUdid(workflow: Workflow, destination: Destination) throws -> String? {
        let availableDestinations = try self.getAvailable(workflow: workflow)
        return availableDestinations.first(where: {
            $0.name == destination.name && $0.platform == destination.platform && $0.os == destination.os
        })?.udid
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
        guard let string = try withOS.os.matches(pattern: #"(-\d+)+"#).first else {
            return nil
        }

        return string.dropFirst().replacingOccurrences(of: "-", with: ".")
    }
}

private struct Response: Decodable {
    let devices: [String: [Device]]
}

private struct Device: Decodable {
    let state: String
    let name: String
    let udid: String
    let isAvailable: Bool
}

private struct DeviceWithOS {
    let device: Device
    let os: String
}
