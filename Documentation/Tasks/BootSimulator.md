 ## Boot a simulator 

 `Destination` is used to identifer a simulator. This is used to launch a simulator

 ```swift
BootSimulator {
    $0.boot(
        destination: .init(
            name: Destination.Name.iPhoneX,
            platform: Destination.Platform.iOSSimulator,
            os: Destination.OS.iOS13_2_2       
        )
    )
}
```