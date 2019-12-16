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

