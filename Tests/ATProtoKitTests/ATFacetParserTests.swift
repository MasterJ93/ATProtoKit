import XCTest
@testable import ATProtoKit

final class ATFacetParserTests: XCTestCase {
    func testURLAtStartIsDetected() {
        let text = "https://example.com is my site"
        let result = ATFacetParser.parseURLs(from: text)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?["link"] as? String, "https://example.com")
        XCTAssertEqual(result.first?["start"] as? Int, 0)
    }

    func testURLAfterSpaceIsDetected() {
        let text = " visit https://example.com now"
        let result = ATFacetParser.parseURLs(from: text)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?["link"] as? String, "https://example.com")
    }

    func testMentionAtStartIsDetected() {
        let text = "@user.bsky.social says hi"
        let result = ATFacetParser.parseMentions(from: text)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?["mention"] as? String, "@user.bsky.social")
        XCTAssertEqual(result.first?["start"] as? Int, 0)
    }

}