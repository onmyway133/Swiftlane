 ## Configure simulator appearance

`UpdateSimulator` can be used to configure a simulator's status bar appearance (such as before taking screenshots)

 ```swift
let destination = Destination(
    name: Destination.Name.iPhoneX,
    platform: Destination.Platform.iOSSimulator,
    os: Destination.OS.iOS13_2_2       
)
UpdateSimulator(destination: destination) 
    .time("9:41")
    .dataNetwork(.wifi)
    .wifiMode(.active)
    .wifiBars(3)
    .cellularMode(.active)
    .cellularBars(4)
    .batteryState(.charged)
    .batteryLevel(97)
```
