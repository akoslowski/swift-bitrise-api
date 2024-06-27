# Bitrise API

The bitrise API comes with a swagger specification (https://api-docs.bitrise.io/docs/swagger.json). The format is in version 2.0. To use the OpenAPI packages we need to convert the specification into the OpenAPI schema version 3.0.x.

## Funny names

The generated client offers the specified operations to e.g. get a list of all apps. The generated method names are not really nice though.

The `app-list` operation specified as `"operationId": "app-list",` will be converted into:

```swift
    func app_hyphen_list(
        query: Operations.app_hyphen_list.Input.Query = .init(),
        headers: Operations.app_hyphen_list.Input.Headers = .init()
    ) async throws -> Operations.app_hyphen_list.Output {
    // ...
}
```

Seems that having a `-` in the specification name is not a good idea.
