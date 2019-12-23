//
//  GetDestinations.swift
//  PumaiOS
//
//  Created by khoa on 20/12/2019.
//

import PumaCore

public class GetDestinations {
    public init() {}

    public func getAvailable(workflow: Workflow) throws -> [Destination] {
        let string = try CommandLine().runBash(
            workflow: workflow,
            program: "xcrun instruments",
            arguments: [
                "-s",
                "devices"
            ]
        )

        // Ex: iPad Air (11.0.1) [7A5EAD29-D870-49FB-9A9B-C81079620AC9] (Simulator)
        let destinations: [Destination] = try string
            .split(separator: "\n")
            .map({ String($0) })
            .filter({ try $0.hasPattern(pattern: #"\[.+\]"#) })
            .compactMap({ (line) -> Destination? in
                parse(line)
            })

        return destinations
    }

    func parse(_ line: String) -> Destination? {
        guard var id = try? line.matches(pattern: #"\[.+\]"#).first else {
            return nil
        }

        var line = line
        line = line.replacingOccurrences(of: id, with: "")
        id = id
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")

        let isSimulator = line.contains("(Simulator)")
        line = line.replacingOccurrences(of: "(Simulator)", with: "")

        var os = (try? line.matches(pattern: #"\((\d+\.)?(\d+\.)?(\*|\d+)\)"#).first) ?? ""
        let name = line
            .replacingOccurrences(of: os, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        os = os.replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")

        let device = self.device(name: name)

        if os.isEmpty {
            return Destination(name: name, id: id)
        } else {
            let platform = isSimulator ? "\(device) Simulator" : device
            return Destination(name: name, platform: platform, os: os)
        }
    }

    // MARK: - Private

    private func device(name: String) -> String {
        if name.starts(with: "iPad") || name.starts(with: "iPhone") {
            return Destination.Platform.iOS
        } else if name.starts(with: "Apple Watch") {
            return Destination.Platform.watchOS
        } else if name.starts(with: "Apple TV") {
            return Destination.Platform.tvOS
        } else if name.contains("Macbook") {
            return Destination.Platform.macOS
        } else {
            return Destination.Platform.iOS
        }
    }
}
