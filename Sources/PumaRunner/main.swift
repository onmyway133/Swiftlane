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
    
    let buildOptions = BuildTask.Options(
        buildOptions: xcodebuildOptions,
        buildsForTesting: true
    )
    
    let testOptions = TestTask.Options(
        buildOptions: xcodebuildOptions,
        destination: Destination(
            platform: Destination.Platform.iOSSimulator,
            name: Destination.Name.iPhoneXr,
            os: Destination.OS.os12_2
        )
    )
    
    let archiveOptions = ArchiveTask.Options(
        buildOptions: xcodebuildOptions,
        archivePath: recommendedArchiveOptions.archivePath
    )
    
    let versionNumberOptions = SetVersionNumberTask.Options(
        buildNumber: "1.1"
    )
    
    let buildNumberOptions = SetBuildNumberTask.Options(
        buildNumber: "2"
    )
    
    let exportArchiveOptions = ExportArchiveTask.Options(
        exportOptionsPlist: nil,
        archivePath: recommendedArchiveOptions.archivePath,
        exportPath: recommendedArchiveOptions.exportPath
    )
    
    let exportPlist = ExportArchiveTask.ExportPlist(
        teamId: "T78DK947F2",
        method: ExportMethod.development
    )
    
    let puma = Puma()
    puma.run(tasks: [
        SetVersionNumberTask(options: versionNumberOptions),
        SetBuildNumberTask(options: buildNumberOptions),
        BuildTask(options: buildOptions),
        TestTask(options: testOptions),
        ArchiveTask(options: archiveOptions),
        ExportArchiveTask(options: exportArchiveOptions, exportPlist: exportPlist)
    ])
}

testDrive()
