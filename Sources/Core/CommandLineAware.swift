//
//  CommandLineAware.swift
//  PumaCore
//
//  Created by khoa on 30/11/2019.
//

import Foundation

/// Any task that uses command line
public protocol CommandLineAware {
    var command: String { get }
    var parameters: Set<String> { get set }
}
