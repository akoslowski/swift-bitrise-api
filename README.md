[![Swift](https://github.com/akoslowski/swift-bitrise-api/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/akoslowski/swift-bitrise-api/actions/workflows/swift.yml)

# BitriseAPI

The bitrise API comes with a swagger specification (https://api-docs.bitrise.io/docs/swagger.json). The format is in version 2.0. To use the swift-openapi packages the specification needs to be converted into the OpenAPI schema version 3.0.x.

Run `make` to update the schema and generate client code.


## Patching

### Undefined build_log operation response model

The current swagger document is not specifing a response model for a successful `build_log` operation.


```
  "200": {
    "description": "OK",
    "schema": {
        "$ref": "#/definitions/v0.BuildLogResponseModel"
    }
  },
```

```
"v0.BuildLogResponseModel": {
  "type": "object",
  "properties": {
    "expiring_raw_log_url": {
      "type": "string"
    },
    "is_archived": {
        "type": "boolean"
    }
  }
},
```

Example response:

```json
{
  "log_chunks": [
    {
      "chunk": "log log log",
      "position": 1
    },
  ],
  "next_before_timestamp": "0001-01-01T00:00:00Z",
  "next_after_timestamp": "0001-01-01T00:00:00Z",
  "is_archived": true,
  "expiring_raw_log_url": "https://storage.googleapis.com/bitrise-build-log-archives-production/apps/abcd"
}
```
