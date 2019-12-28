## Tips and tricks

Here are some tips and tricks to work with Puma more efficiently

## Environment variables

When Puma is run as a macOS command line library, you can access environment variables via `ProcessInfo`

```swift
UploadApp {
    $0.authenticate(
        username: ProcessInfo().environment["username"]!,
        password: ProcessInfo().environment["password"]!
    )

    $0.upload(
        ipaPath: Directory.downloads.appendingPathComponent("TestApp.ipa").path
    )
}
```

## Directory

Puma encourages explicity, so you have to provide explicit paths. Instead of typing path like `/Users/khoa/Downloads`,you can use the `Directory` class which provides nifty properties for popular locations, they are file `URL` so you can append path component further.

```swift
Directory.home
Directory.downloads
Directory.applications
```