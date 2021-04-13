## How to compile Puma from source

Normally you should just use the TestPuma inside Example folder to quickly test drive Puma. But if you want to compile it from source using Swift Package Manager command line tool, then follow

Head over to [Swift Package Manager usage](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) to create an executable.

There's an already created [ManualCompile](https://github.com/pumaswift/Puma/tree/develop/Example/TestApp/ManualCompile) for your reference.

Step 1: In your project folder, run these to create Swift Package Manager structure. Create another folder called, for example ManualCompile to keep our script.

```sh
mkdir ManualCompile
cd ManualCompile
swift package init --type executable
```

Step 2: Edit the newly generated `Package.swift` to include Puma

```swift
// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ManualCompile",
    platforms: [.macOS("10.14")],
    dependencies: [
        .package(
            url: "https://github.com/pumaSwift/Puma.git",
            .upToNextMajor(from: "0.0.1")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ManualCompile",
            dependencies: [
                "Puma"
            ]
        ),
        .testTarget(
            name: "ManualCompileTests",
            dependencies: ["ManualCompile"]),
    ]
)
```

Step 3: Go to ManualCompile/Sources/ManualCompile/main.swift, import Puma and declare the tasks. 

Step 4: Run 

```
swift build
```

This will fetch dependencies and build our executable.

Step 5: Copy the built ManualCompile executable from `Example/TestApp/ManualCompile/.build/debug/ManualCompile` to our `TestApp` folder

```sh
cp -f ./.build/debug/ManualCompile ../puma
```

Now we should have the executable `puma` in our project folder.

Step 6: In our project folder, run `./puma` to see Puma in action

```
./puma
```
