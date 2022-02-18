//
//  main.swift
//  Script
//
//  Created by Khoa on 16/02/2022.
//

import Swiftlane
import AppStoreConnect
import Foundation

@main
struct Script {
    static func main() async throws {
        try await deployMyApp()
    }

    private static func deployMyApp() async throws {
        var workflow = Workflow()
        workflow.directory = Settings.fs
            .homeDirectory
            .appendingPathComponent("XcodeProject2/swiftlane/Examples/MyApp")
        workflow.xcodeApp = Settings.fs.applicationsDirectory.appendingPathComponent("Xcode.app")

        let build = Build()
        build.project("MyApp")
        build.allowProvisioningUpdates()
        build.destination(platform: .iOSSimulator, name: "iPhone 13")
        build.workflow = workflow
//        try await build.run()

        guard
            let issuerId = Settings.env["ASC_ISSUER_ID"],
            let privateKeyId = Settings.env["ASC_PRIVATE_KEY_ID"],
            let privateKey = Settings.env["ASC_PRIVATE_KEY"]
        else { return }

        let asc = try ASC(
            credential: AppStoreConnect.Credential(
                issuerId: issuerId,
                privateKeyId: privateKeyId,
                privateKey: privateKey
            )
        )

        let buildNumber = try await asc.fetchLatestTestFlightBuildNumber(
            filterVersion: "2.8.9",
            filterApp: "1503446680"
        )

        let keychain = try await Keychain.create(
            path: Keychain.Path(
                rawValue: Settings.fs
                    .downloadsDirectory
                    .appendingPathComponent("k3.keychain")),
            password: "abc"
        )
        /*
        try await keychain.unlock()
        try await keychain.addToSearchablePaths()
        try await keychain.import(
            certificateFile: Settings.fs
                .downloadsDirectory
                .appendingPathComponent("abcpass.p12"),
            certificatePassword: "123"
        )
        */

        /*
        let appCenter = AppCenter()
        try await appCenter.upload(
            appId: "",
            ipaFile: URL(string: "/Downloads")!,
            token: "",
            distributionGroup: ""
        )
        */
    }
}
