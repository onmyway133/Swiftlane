import Puma

func testDrive() {
    let automaticSigning = AutomaticSigning(teamId: "T78DK947F2")
    let recommendedArchiveOptions = OptionFactory().makeArchiveOptions(name: "TestApp")
    
    let xcodebuildOptions = Xcodebuild.Options(
        workspace: nil,
        project: "TestApp",
        scheme: "TestApp",
        configuration: Configuration.release,
        sdk: Sdk.iPhone,
        signing: .auto(automaticSigning),
        usesModernBuildSystem: true
    )

    run {
        SetVersionNumber(options: .init(buildNumber: "1.1"))
        SetBuildNumber(options: .init(buildNumber: "2"))

        Build(options: .init(
            buildOptions: xcodebuildOptions,
            buildsForTesting: true)
        )

        Test(options: .init(
            buildOptions: xcodebuildOptions,
            destination: Destination(
                platform: Destination.Platform.iOSSimulator,
                name: Destination.Name.iPhoneXr,
                os: Destination.OS.os12_2
            )
        ))

        Archive(options: .init(
            buildOptions: xcodebuildOptions,
            archivePath: recommendedArchiveOptions.archivePath
        ))

        ExportArchive(
            options: .init(
                exportOptionsPlist: nil,
                archivePath: recommendedArchiveOptions.archivePath,
                exportPath: recommendedArchiveOptions.exportPath
            ),
            exportPlist: .init(
                teamId: "T78DK947F2",
                method: ExportMethod.development
            )
        )
    }
}

testDrive()
