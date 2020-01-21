//
//  GetDestinations.swift
//  PumaiOS
//
//  Created by khoa on 20/12/2019.
//

import PumaCore
import Foundation

/// Runs xcrun and gets list of available simulators
public struct GetListOfDevicesCommand {
    
    public static func execute(with workflow: Workflow) -> String? {
        return try? CommandLine().runBash(
            workflow: workflow,
            program: "xcrun simctl",
            arguments: [
                "list",
                "devices",
                "-j"
            ],
            processHandler: DefaultProcessHandler(
                logger: workflow.logger, filter: { $0.starts(with: "name=") }
            )
        )
    }
    
}

public class GetDestinations {
    public typealias BashCommand = (Workflow) -> String?
    private let bashCommand: BashCommand
    
    public init(bashCommand: @escaping BashCommand = GetListOfDevicesCommand.execute) {
        self.bashCommand = bashCommand
    }

    public func getAvailable(workflow: Workflow) throws -> [Destination] {
        guard let consoleOutput = bashCommand(workflow) else {
            throw PumaError.invalid
        }
        
        guard let devices = parse(output: consoleOutput) else {
            throw PumaError.invalid // TODO: improve
        }

        let destinations: [Destination] = devices
            .filter { $0.isAvailable }
            .compactMap { device in
                guard let os = device.supportedOS else { return nil }
                guard let platform = device.supportedPlatform else { return nil }
                
                return Destination(
                    name: device.name,
                    platform: platform,
                    os: os,
                    udid: device.udid
                )
            }

        return destinations
    }

    func findUdid(workflow: Workflow, destination: Destination) throws -> String? {
        let available = try? getAvailable(workflow: workflow)
        return available?.first { $0 == destination }?.udid
    }
    
    // MARK: Private
    private func parse(output: String) -> [Device]? {
        guard let data = output.data(using: .utf8) else {
            return nil
        }

        struct DevicesMapJSON: Decodable {
            typealias OS = String
            typealias DevicesMap = [OS : [Device]]
            
            let devices: DevicesMap
        }
        
        let devicesMap = try? JSONDecoder().decode(DevicesMapJSON.self, from: data)
        return devicesMap?.devices.flatMap { (arg) -> [Device] in
            let (key, value) = arg
            return value.map { Device(
                state: $0.state,
                name: $0.name,
                udid: $0.udid,
                isAvailable: $0.isAvailable,
                os: key)
            }
        }
    }
}

struct Device: Decodable {
    let state: String
    let name: String
    let udid: String
    let os: String
    let isAvailable: Bool
    
    init(state: String, name: String, udid: String, isAvailable: Bool, os: String = "") {
        self.state = state
        self.name = name
        self.udid = udid
        self.os = os
        self.isAvailable = isAvailable
    }
}

extension Device {
    var supportedPlatform: Destination.Platform? {
        guard let currentPlatform = Destination.Platform(rawValue: os) else { return nil }
        guard Destination.Platform.allSupported.contains(currentPlatform) else { return nil }
        
        return currentPlatform
    }

    // com.apple.CoreSimulator.SimRuntime.iOS-13-2
    var supportedOS: String? {
        guard let string = try? os.matches(pattern: #"(-\d+)+"#).first else {
            return nil
        }

        return string.dropFirst().replacingOccurrences(of: "-", with: ".")
    }
}
