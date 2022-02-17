//
//  Keychain.swift
//  Swiftlane
//
//  Created by Khoa on 17/02/2022.
//

import Foundation

public struct Keychain {
    let path: Path
    let password: String

    public init(
        path: Path,
        password: String
    ) {
        self.path = path
        self.password = password
    }

    public static func create(
        path: Path,
        password: String
    ) async throws -> Keychain {
        guard !Settings.fs.exists(url: path.rawValue) else {
            return Keychain(
                path: path,
                password: password
            )
        }

        var args = Args()
        args.flag("create-keychain")
        args["-p"] = password.surroundingWithQuotes()
        args.suffix = [path.rawValue.path.surroundingWithQuotes()]

        try Settings.cli.run(
            program: "security",
            argument: args.toString()
        )

        return Keychain(
            path: path,
            password: password
        )
    }

    public func unlock() async throws {
        var args = Args()
        args.flag("unlock-keychain")
        args["-p"] = password.surroundingWithQuotes()
        args.suffix = [path.rawValue.path.surroundingWithQuotes()]

        try Settings.cli.run(
            program: "security",
            argument: args.toString()
        )
    }

    public func `import`(
        certificateFile: URL,
        certificatePassword: String? = nil
    ) async throws {
        var args = Args()
        args["import"] = certificateFile.path.surroundingWithQuotes()
        args[multiple: "-T"] = "/usr/bin/codesign"
        args[multiple: "-T"] = "/usr/bin/security"
        args[multiple: "-T"] = "/usr/bin/productbuild"
        args["-k"] = path.rawValue.path.surroundingWithQuotes()

        if let certificatePassword = certificatePassword {
            args["-P"] = certificatePassword.surroundingWithQuotes()
        }

        try Settings.cli.run(
            program: "security",
            argument: args.toString()
        )
    }
}

public extension Keychain {
    struct Path {
        public var rawValue: URL
        public init(rawValue: URL) {
            self.rawValue = rawValue
        }

        public static var login: Path {
            Path(
                rawValue: Settings.fs.keychainsDirectory
                    .appendingPathComponent("login.keychain")
            )
        }
    }
}
