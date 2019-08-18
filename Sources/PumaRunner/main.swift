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
        SetVersionNumberTask(options: .init(buildNumber: "1.1"))
        SetBuildNumberTask(options: .init(buildNumber: "2"))

        BuildTask(options: .init(
            buildOptions: xcodebuildOptions,
            buildsForTesting: true)
        )

        TestTask(options: .init(
            buildOptions: xcodebuildOptions,
            destination: Destination(
                platform: Destination.Platform.iOSSimulator,
                name: Destination.Name.iPhoneXr,
                os: Destination.OS.os12_2
            )
        ))

        ArchiveTask(options: .init(
            buildOptions: xcodebuildOptions,
            archivePath: recommendedArchiveOptions.archivePath
        ))

        ExportArchiveTask(
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
