import XCTest
@testable import ATProtoKit

final class ATProtoKitTests: XCTestCase {
    func testSessionServiceEndpointBuildsAuthenticatedWrapperRequestURL() throws {
        let pdsURL = "https://bsky.social"
        let serviceEndpoint = try XCTUnwrap(URL(string: "https://pds.host.bsky.network"))
        let session = UserSession(
            handle: "alice.example.com",
            sessionDID: "did:plc:alice",
            isEmailAuthenticationFactorEnabled: false,
            isActive: true,
            status: nil,
            serviceEndpoint: serviceEndpoint,
            pdsURL: pdsURL
        )

        let requestURL = try XCTUnwrap(URL(string: "\(session.serviceEndpoint.absoluteString)/xrpc/com.atproto.server.getSession"))
        XCTAssertEqual(requestURL.host, "pds.host.bsky.network")
        XCTAssertNotEqual(requestURL.host, URL(string: pdsURL)?.host)
        XCTAssertEqual(requestURL.absoluteString, "https://pds.host.bsky.network/xrpc/com.atproto.server.getSession")

        let matchingPDSURL = "https://pds.host.bsky.network"
        let matchingServiceEndpoint = try XCTUnwrap(URL(string: matchingPDSURL))
        let matchingSession = UserSession(
            handle: "alice.example.com",
            sessionDID: "did:plc:alice",
            isEmailAuthenticationFactorEnabled: false,
            isActive: true,
            status: nil,
            serviceEndpoint: matchingServiceEndpoint,
            pdsURL: matchingPDSURL
        )

        let matchingRequestURL = try XCTUnwrap(URL(string: "\(matchingSession.serviceEndpoint.absoluteString)/xrpc/com.atproto.server.getSession"))
        XCTAssertEqual(matchingRequestURL.host, URL(string: matchingPDSURL)?.host)
        XCTAssertEqual(matchingRequestURL.absoluteString, "https://pds.host.bsky.network/xrpc/com.atproto.server.getSession")
    }

    func testSetQueryItemsPercentEncodesPlusSigns() throws {
        let apiClientService = APIClientService(with: APIClientConfiguration())
        let requestURL = try XCTUnwrap(URL(string: "https://example.com/xrpc/app.bsky.feed.getFeed"))

        let urlWithPlus = try apiClientService.setQueryItems(for: requestURL, with: [
            ("cursor", "abc+def")
        ])
        XCTAssertEqual(urlWithPlus.absoluteString, "https://example.com/xrpc/app.bsky.feed.getFeed?cursor=abc%2Bdef")
        XCTAssertFalse(urlWithPlus.absoluteString.contains("+"))

        let urlWithoutPlus = try apiClientService.setQueryItems(for: requestURL, with: [
            ("cursor", "abcdef")
        ])
        XCTAssertEqual(urlWithoutPlus.absoluteString, "https://example.com/xrpc/app.bsky.feed.getFeed?cursor=abcdef")
        XCTAssertFalse(urlWithoutPlus.absoluteString.contains("+"))

        let urlWithMultipleItems = try apiClientService.setQueryItems(for: requestURL, with: [
            ("cursor", "abc+def"),
            ("limit", "50")
        ])
        XCTAssertEqual(urlWithMultipleItems.absoluteString, "https://example.com/xrpc/app.bsky.feed.getFeed?cursor=abc%2Bdef&limit=50")
        XCTAssertFalse(urlWithMultipleItems.absoluteString.contains("+"))
    }
}
