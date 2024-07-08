# ``BitriseAPI``

The Bitrise API allows you to build deep, custom integrations with your preferred tools and processes to create even more efficient development pipelines.

The API provides you with control of - and access to - the features and data available through the Bitrise website and CLI. By using the API, you gain the ability to fully customize Bitrise’s functionality to fit your process.

[https://devcenter.bitrise.io/en/api.html](https://devcenter.bitrise.io/en/api.html)

> Warning: **The API is work-in-progress**
>
> The API is work-in-progress: we will add new endpoints and possibly update the existing ones in the future.
>
> You can track the progress of the API: [join the discussion](https://discuss.bitrise.io/t/bitrise-api-v0-1-work-in-progress/1554)! Follow it and get notified about new endpoints and changes, we announce those there.

## Basic usage

Running the code requires to create a personal access token. See [Authenticating with the Bitrise API](https://devcenter.bitrise.io/en/api/authenticating-with-the-bitrise-api.html) for more details.

The example uses [OpenAPIURLSession](https://github.com/apple/swift-openapi-urlsession) which needs to be declared as a Swift Package dependency.

The following code sets up a client with ``Client/init(serverURL:configuration:transport:middlewares:)`` and makes a request to list the configured applications for your account using ``Client/app_list(_:)``.

```swift
import OpenAPIURLSession
import BitriseAPI

func printAppList() async throws {
    let config: URLSessionConfiguration = .default
    let personalAccessToken = "<ACCESS-TOKEN>"
    config.httpAdditionalHeaders = [ "Authorization": personalAccessToken ]

    let client = Client(
        serverURL: try Servers.server1(),
        transport: URLSessionTransport(
            configuration: URLSessionTransport.Configuration(
                session: .init(configuration: config)
            )
        )
    )

    let response = try await client.app_list()

    switch response {
    case .ok(let output):
        let apps = try output.body.json.data
        let titles = apps?.compactMap { app in
            app.title
        }
        print(titles ?? [])

    case .badRequest:
        break
    case .unauthorized:
        break
    case .notFound:
        break
    case .internalServerError:
        break
    case .undocumented:
        break
    }
}
```
