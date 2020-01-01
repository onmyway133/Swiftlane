 ## Update status bar of a simulator

`Destination` is used to identifer a simulator, this should be run before taking screenshots

 ```swift
UpdateSimulator {
    $0.updateStatusBar(
        destination: .init(
            name: Destination.Name.iPhoneX,
            platform: Destination.Platform.iOSSimulator,
            os: Destination.OS.iOS13_2_2       
        ),
        time: "9:41",
        dataNetwork: .wifi,
        wifiMode: WifiMode = .active,
        wifiBars: String = "3",
        cellularMode: CellularMode = .active,
        cellularBars: String = "4",
        batteryState: BatteryState = .charged,
        batteryLevel: String = "97"
    )
}
```