[![Swift](https://github.com/akoslowski/swift-bitrise-api/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/akoslowski/swift-bitrise-api/actions/workflows/swift.yml)

# BitriseAPI

The bitrise API comes with a swagger specification (https://api-docs.bitrise.io/docs/swagger.json). The format is in version 2.0. To use the swift-openapi packages the specification needs to be converted into the OpenAPI schema version 3.0.x.

Run `make` to update the schema and generate client code.
