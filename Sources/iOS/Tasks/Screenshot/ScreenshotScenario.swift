//
//  Scenario.swift
//  PumaiOS
//
//  Created by khoa on 09/12/2019.
//

import Foundation
import PumaCore

public extension Screenshot {
    struct Scenario {
        public let destination: Destination
        public let language: String
        public let locale: String

        public init(
            destination: Destination,
            language: String = Language.en_US,
            locale: String = Language.en_US) {
            self.destination = destination
            self.language = language
            self.locale = locale
        }
    }
}
