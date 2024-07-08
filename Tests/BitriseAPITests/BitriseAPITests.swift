@testable import BitriseAPI
import HTTPTypes
import OpenAPIRuntime
import XCTest

final class BitriseAPITests: XCTestCase {
    func testEmptyResponse() async throws {
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

        let client = try Client(
            serverURL: Servers.server1(),
            transport: StaticResponseTransport(response: transportResponse)
        )

        let response = try await client.appList()

        let apps = try XCTUnwrap(response.ok.body.json.data)
        XCTAssertTrue(apps.isEmpty)

        let paging = try XCTUnwrap(response.ok.body.json.paging)
        XCTAssertEqual(paging.value1.total_item_count, 0)
    }

    func testAppResponse() async throws {
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

        let client = try Client(
            serverURL: Servers.server1(),
            transport: StaticResponseTransport(response: transportResponse)
        )

        let response = try await client.appList()

        let app = try XCTUnwrap(response.ok.body.json.data?.first)
        XCTAssertEqual(app.title, "some-app-title")
        XCTAssertEqual(app.owner?.account_type, "organization")

        let paging = try XCTUnwrap(response.ok.body.json.paging)
        XCTAssertEqual(paging.value1.total_item_count, 1)
    }
}

private struct StaticResponseTransport: ClientTransport {
    let response: (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?)

    func send(
        _: HTTPTypes.HTTPRequest,
        body _: OpenAPIRuntime.HTTPBody?,
        baseURL _: URL,
        operationID _: String
    ) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        response
    }
}
