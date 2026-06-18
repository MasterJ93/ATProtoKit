import XCTest
@testable import ATProtoKit

final class ATProtoKitTests: XCTestCase {
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
