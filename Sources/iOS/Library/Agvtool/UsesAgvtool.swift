//
//  UsesAgvtool.swift
//  PumaiOS
//
//  Created by khoa on 09/12/2019.
//

import Foundation
import PumaCore

/// Any task that uses avgtool
public protocol UsesAgvtool: UsesCommandLine {
    var agvtool: Agvtool { get set }
}

public extension UsesAgvtool {
    func runAgvtool(workflow: Workflow) throws {
        try runBash(
            workflow: workflow,
            program: "agvtool",
            arguments: agvtool.arguments
        )
    }
}
