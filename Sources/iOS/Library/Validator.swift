//
//  Validator.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore

public struct Validator {
    public static func deviceBuildMustHaveCodeSign(options: Xcodebuild.Options) throws {
        if let sdk = options.sdk, sdk == Sdk.iPhone && options.signing == nil {
            throw PumaError.validate("Device build must have code sign")
        }
    }
}
