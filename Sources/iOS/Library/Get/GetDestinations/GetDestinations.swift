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
            program: "instruments",
            arguments: [
                "-s",
                "devices"
            ]
        )

        // Ex: iPad Air (11.0.1) [7A5EAD29-D870-49FB-9A9B-C81079620AC9] (Simulator)
        let destinations: [Destination] = try string
            .split(separator: "\n")
            .map({ String($0) })
            .filter({ try $0.hasPattern(#"\[.+\]"#) })
            .map({ (line) -> Destination in
                parse(line)
            })

        return destinations
    }

    private func parse(_ line: String) -> Destination {
        fatalError()
    }
}
