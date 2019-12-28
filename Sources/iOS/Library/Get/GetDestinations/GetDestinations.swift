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

        let destinations: [Destination] = devicesWithOS
            .filter({ withOS in
                return withOS.device.isAvailable
            })
            .map({ withOS in
                var destination = Destination(name: withOS.device.name, platform: "", os: "")
                destination.id = withOS.device.uuid
                return destination
            })

        return destinations
    }

    func findId(workflow: Workflow, destination: Destination) throws -> String? {
        let availableDestinations = try self.getAvailable(workflow: workflow)
        return availableDestinations.first(where: { $0 == destination })?.id
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
