//
//  Directory.swift
//  PumaCore
//
//  Created by khoa on 28/12/2019.
//

import Foundation

public struct Directory {
    public static let home: URL = FileManager.default.homeDirectoryForCurrentUser
    public static let downloads = Self.home.appendingPathComponent("Downloads")
    public static let applications = Self.home.appendingPathComponent("Applications")
}
