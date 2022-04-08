//
//  Script.swift
//  Script
//
//  Created by Khoa on 16/02/2022.
//

import Swiftlane
import AppStoreConnect

@main
public struct Script {
    static func main() async throws {
        try await deployMyApp()
    }

    private static func deployMyApp() async throws {
        var workflow = Workflow()
        workflow.directory = try await Settings.fs
            .currentDirectory()
            .deletingLastPathComponent()
            .appendingPathComponent("MyApp")

        let build = Build()
        build.project("MyApp")
        build.workflow = workflow
        try await build.run()

        guard
            let issuerId = Settings.env["ASC_ISSUER_ID"],
            let privateKeyId = Settings.env["ASC_PRIVATE_KEY_ID"],
            let privateKey = Settings.env["ASC_PRIVATE_KEY"]
        else { return }

        let _ = try ASC(
            credential: AppStoreConnect.Credential(
                issuerId: issuerId,
                privateKeyId: privateKeyId,
                privateKey: privateKey
            )
        )
    }
}
