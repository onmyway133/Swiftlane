//
//  Deps.swift
//  Puma
//
//  Created by khoa on 30/11/2019.
//

import Foundation

public struct Deps {
    public static var console = Console()
    public static var date: () -> Date = { Date() }
}
