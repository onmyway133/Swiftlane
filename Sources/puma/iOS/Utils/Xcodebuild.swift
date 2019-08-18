//
//  XcodeBuild.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct Xcodebuild {
    public struct Options {
        ///  build the workspace NAME
        public let workspace: String?
        /// build the project NAME
        public let project: String
        /// build the scheme NAME
        public let scheme: String
        /// use the build configuration NAME for building each target
        public let configuration: String
        /// use SDK as the name or path of the base SDK when building the project
        public let sdk: String?
        public let signing: Signing?
        public let usesModernBuildSystem: Bool
        
        public init(
            workspace: String? = nil,
            project: String,
            scheme: String,
            configuration: String = Configuration.debug,
            sdk: String? = Sdk.iPhoneSimulator,
            signing: Signing? = nil,
            usesModernBuildSystem: Bool = true) {
            
            self.workspace = workspace
            self.project = project
            self.scheme = scheme
            self.configuration = configuration
            self.sdk = sdk
            self.signing = signing
            self.usesModernBuildSystem = usesModernBuildSystem
        }
    }
}

extension Xcodebuild.Options {
    func toArguments() -> [String: String?] {
        let arguments = [
            "-workspace ": workspace.map({ $0.addingFileExtension("xcworkspace") }),
            "-project ": project.addingFileExtension("xcodeproj"),
            "-scheme ": scheme,
            "-configuration ": configuration,
            "-sdk ": sdk,
            "-UseModernBuildSystem=": usesModernBuildSystem ? "YES": "NO"
        ]
        
        return arguments
            .simpleMerging(signing?.toArguments())
    }
}
