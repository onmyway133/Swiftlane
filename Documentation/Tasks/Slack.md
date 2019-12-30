## Slack 

### Post message to a channel in Slack

Follow [Create a bot for your workspace](https://slack.com/intl/en-no/help/articles/115005265703-create-a-bot-for-your-workspace) to create, add a bot to your workspace. Obtain `Bot User OAuth Access Token` to use to authenticate

```swift
Slack {
    $0.post(
        message: .init(
            token: ProcessInfo().environment["slackBotToken"]!,
            channel: "random",
            text: "Hello from Puma",
            username: "onmyway133"
        )
    )
}
```