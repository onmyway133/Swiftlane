//
//  UpdateSimulator.swift
//  PumaiOS
//
//  Created by khoa on 28/12/2019.
//

import Foundation
import PumaCore

public class UpdateSimulator {
    public var name: String = "Update simulator"
    public var isEnabled = true

    private var simclt = Simclt()

    private let destination: Destination?

    private var arguments: [String: String] = [:]

    public init(destination: Destination? = nil) {
        self.destination = destination
    }
}

// MARK: - Modifiers

public extension UpdateSimulator {
    func time(_ time: String) -> Self {
        arguments["--time"] = time
        return self
    }

    func dataNetwork(_ network: DataNetwork) -> Self {
        arguments["--dataNetwork"] = network.rawValue
        return self
    }

    func wifiMode(_ mode: WifiMode) -> Self {
        arguments["--wifiMode"] = mode.rawValue
        return self
    }

    func wifiBars(_ bars: Int) -> Self {
        arguments["--wifiBars"] = String(bars)
        return self
    }

    func cellularMode(_ mode: CellularMode) -> Self {
        arguments["--cellularMode"] = mode.rawValue
        return self
    }

    func cellularBars(_ bars: Int) -> Self {
        arguments["--cellularBars"] = String(bars)
        return self
    }

    func batteryState(_ state: BatteryState) -> Self {
        arguments["--batteryState"] = state.rawValue
        return self
    }

    func batteryLevel(_ level: Int) -> Self {
        arguments["--batteryLevel"] = String(level)
        return self
    }
}

// MARK: - Task

extension UpdateSimulator: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        arguments.forEach { key, value in
            simclt.arguments.append(contentsOf: [key, value])
        }

        handleTryCatch(completion) {
            let getDestinations = GetDestinations()
            if let destination = destination {
                if let udid = try getDestinations.findUdid(workflow: workflow, destination: destination) {
                    simclt.arguments.insert(udid, at: 1)
                } else {
                    throw PumaError.invalid
                }
            } else {
                simclt.arguments.insert("booted", at: 1)
            }

            try simclt.run(workflow: workflow)
        }
    }
}

public extension UpdateSimulator {
    enum DataNetwork: String {
        case wifi
        case _3g = "3g"
        case _4g = "4g"
        case lte
        case lteA = "lte-a"
        case ltePlus = "lte+"
    }

    enum WifiMode: String {
        case searching, failed, active
    }

    enum CellularMode: String {
        case notSupported, searching, failed, active
    }

    enum BatteryState: String {
        case charging, charged, discharging
    }
}
