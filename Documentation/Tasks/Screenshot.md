## Take screenshot

### Create UITest scheme

Puma leverages UITest scheme to take screenshot. You are also encouraged to use test plan feature of Xcode 11, but not required.

Use a simple `takeScreenshot` below to take screenshot, remember to specify life time to keep always

```swift
class TestAppUITests: XCTestCase {
    func testFirstScreen() {
        let app = XCUIApplication()
        app.launch()

        takeScreenshot(name: "MainScreen")
    }

    func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attach = XCTAttachment(screenshot: screenshot)
        attach.lifetime = .keepAlways
        add(attach)
    }
}
```

Then in Puma, we can use `Screenshot` task

```swift
Screenshot()
    .project("TestApp")
    .appScheme("TestApp")
    .uiTestScheme("TestAppUITests")
    .saveDirectory(Directory.downloads.appendingPathComponent("PumaScreenshots").path)
    .scenarios(
        .init(
            destination: .init(
                name: Destination.Name.iPhone11,
                platform: Destination.Platform.iOSSimulator,
                os: Destination.OS.iOS13_2_2
            ),
            language: Language.en_US,
            locale: Locale.en_US
        ),
        .init(
            destination: .init(
                name: Destination.Name.iPhone11Pro,
                platform: Destination.Platform.iOSSimulator,
                os: Destination.OS.iOS13_2_2
            ),
            language: Language.ja,
            locale: Locale.ja
        )
    )
```
