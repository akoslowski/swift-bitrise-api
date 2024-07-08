@testable import BitriseAPI
import HTTPTypes
import OpenAPIRuntime
import XCTest

final class BitriseAPITests: XCTestCase {
    func testAppsEmptyResponse() async throws {
        let transportResponse: (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) = (
            .init(status: .ok),
            """
            {
              "data": [],
              "paging": {
                "total_item_count": 0,
                "page_item_limit": 50
              }
            }
            """
        )

        let client = try await Client(
            serverURL: Servers.server1(),
            transport: StaticResponseTransport(response: transportResponse)
        )

        let response = try await client.app_list()

        let apps = try XCTUnwrap(response.ok.body.json.data)
        XCTAssertTrue(apps.isEmpty)

        let paging = try XCTUnwrap(response.ok.body.json.paging)
        XCTAssertEqual(paging.value1.total_item_count, 0)
    }

    func testAppsResponse() async throws {
        let transportResponse: (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) = (
            .init(status: .ok),
            """
            {
              "data": [
                {
                  "slug": "some-slug",
                  "title": "some-app-title",
                  "project_type": "other",
                  "provider": "github",
                  "repo_owner": "some-repo-owner",
                  "repo_url": "git@github.com:SomeOrg/some-repo",
                  "repo_slug": "some-repo",
                  "is_disabled": false,
                  "status": 2,
                  "is_public": true,
                  "is_github_checks_enabled": false,
                  "owner": {
                    "account_type": "organization",
                    "name": "Some Org",
                    "slug": "some-org-slug"
                  },
                  "avatar_url": "https://concrete-userfiles-production.s3.us-west-2.amazonaws.com/repositories/some-app/avatar/avatar.jpg"
                },
              ],
              "paging": {
                "total_item_count": 1,
                "page_item_limit": 50
              }
            }
            """
        )

        let client = try await Client(
            serverURL: Servers.server1(),
            transport: StaticResponseTransport(response: transportResponse)
        )

        let response = try await client.app_list()

        let app = try XCTUnwrap(response.ok.body.json.data?.first)
        XCTAssertEqual(app.title, "some-app-title")
        XCTAssertEqual(app.owner?.account_type, "organization")

        let paging = try XCTUnwrap(response.ok.body.json.paging)
        XCTAssertEqual(paging.value1.total_item_count, 1)
    }

    func testBuildsResponse() async throws {
        let transportResponse: (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) = (
            .init(status: .ok),
            """
            {
              "data": [],
              "paging": {
                "total_item_count": 0,
                "page_item_limit": 50
              }
            }
            """
        )

        let transport = await StaticResponseTransport(response: transportResponse)
        let client = Client(
            serverURL: try Servers.server1(),
            transport: transport
        )

        let response = try await client.build_list(path: .init(app_slug: "some-app-slug"))

        let input = await transport.input
        XCTAssertEqual(input?.request.path, "/apps/some-app-slug/builds")
        XCTAssertEqual(input?.operationID, "build_list")

        let apps = try XCTUnwrap(response.ok.body.json.data)
        XCTAssertTrue(apps.isEmpty)
    }
}

// MARK: -

@MainActor
private final class StaticResponseTransport: ClientTransport {
    let response: (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?)
    private(set) var input: (
        request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String
    )?

    init(response: (HTTPResponse, HTTPBody?)) {
        self.response = response
    }

    func send(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String
    ) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        input = (request, body, baseURL, operationID)
        return response
    }
}
