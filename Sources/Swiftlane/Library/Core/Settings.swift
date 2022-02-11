//
//  File.swift
//  
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct Settings {
    public static var `default` = Settings()

    public var env = Environment()
    public var fs = FileSystem()
    public var cs = Console()
    public var cli = CommandLine()
}
