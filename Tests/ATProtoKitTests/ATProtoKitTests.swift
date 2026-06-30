import Foundation
import Testing
@testable import ATProtoKit

@Suite("ATFacetParser Tests")
struct ATFacetParserTests {

    struct ByteRange: Equatable {
        let byteStart: Int
        let byteEnd: Int
    }

    struct LinkExpectation: Equatable {
        let text: String
        let uri: String
    }

    @Test("Session service endpoint builds authenticated wrapper request URL")
    func sessionServiceEndpointBuildsAuthenticatedWrapperRequestURL() throws {
        let pdsURL = "https://bsky.social"
        let serviceEndpoint = try #require(URL(string: "https://pds.host.bsky.network"))
        let session = UserSession(
            handle: "alice.example.com",
            sessionDID: "did:plc:alice",
            isEmailAuthenticationFactorEnabled: false,
            isActive: true,
            status: nil,
            serviceEndpoint: serviceEndpoint,
            pdsURL: pdsURL
        )

        let requestURL = try #require(URL(string: "\(session.serviceEndpoint.absoluteString)/xrpc/com.atproto.server.getSession"))
        #expect(requestURL.host == "pds.host.bsky.network")
        #expect(requestURL.host != URL(string: pdsURL)?.host)
        #expect(requestURL.absoluteString == "https://pds.host.bsky.network/xrpc/com.atproto.server.getSession")

        let matchingPDSURL = "https://pds.host.bsky.network"
        let matchingServiceEndpoint = try #require(URL(string: matchingPDSURL))
        let matchingSession = UserSession(
            handle: "alice.example.com",
            sessionDID: "did:plc:alice",
            isEmailAuthenticationFactorEnabled: false,
            isActive: true,
            status: nil,
            serviceEndpoint: matchingServiceEndpoint,
            pdsURL: matchingPDSURL
        )

        let matchingRequestURL = try #require(URL(string: "\(matchingSession.serviceEndpoint.absoluteString)/xrpc/com.atproto.server.getSession"))
        #expect(matchingRequestURL.host == URL(string: matchingPDSURL)?.host)
        #expect(matchingRequestURL.absoluteString == "https://pds.host.bsky.network/xrpc/com.atproto.server.getSession")
    }

    @Test("Query items percent encode plus signs")
    func setQueryItemsPercentEncodesPlusSigns() throws {
        let apiClientService = APIClientService(with: APIClientConfiguration())
        let requestURL = try #require(URL(string: "https://example.com/xrpc/app.bsky.feed.getFeed"))

        let urlWithPlus = try apiClientService.setQueryItems(for: requestURL, with: [
            ("cursor", "abc+def")
        ])
        #expect(urlWithPlus.absoluteString == "https://example.com/xrpc/app.bsky.feed.getFeed?cursor=abc%2Bdef")
        #expect(urlWithPlus.absoluteString.contains("+") == false)

        let urlWithoutPlus = try apiClientService.setQueryItems(for: requestURL, with: [
            ("cursor", "abcdef")
        ])
        #expect(urlWithoutPlus.absoluteString == "https://example.com/xrpc/app.bsky.feed.getFeed?cursor=abcdef")
        #expect(urlWithoutPlus.absoluteString.contains("+") == false)

        let urlWithMultipleItems = try apiClientService.setQueryItems(for: requestURL, with: [
            ("cursor", "abc+def"),
            ("limit", "50")
        ])
        #expect(urlWithMultipleItems.absoluteString == "https://example.com/xrpc/app.bsky.feed.getFeed?cursor=abc%2Bdef&limit=50")
        #expect(urlWithMultipleItems.absoluteString.contains("+") == false)
    }

    @Test("Mentions are detected with Bluesky rich text rules")
    func detectsMentionsInline() {
        let testCases: [(input: String, mentions: [String])] = [
            ("no mention", []),
            ("@handle.com middle end", ["@handle.com"]),
            ("start @handle.com end", ["@handle.com"]),
            ("start middle @handle.com", ["@handle.com"]),
            ("@handle.com @handle.com @handle.com", ["@handle.com", "@handle.com", "@handle.com"]),
            ("@full123-chars.test", ["@full123-chars.test"]),
            ("not@right", []),
            ("@handle.com!@#$chars", ["@handle.com"]),
            ("@handle.com\n@handle.com", ["@handle.com", "@handle.com"]),
            ("parenthetical (@handle.com)", ["@handle.com"]),
            ("👨‍👩‍👧‍👧 @handle.com 👨‍👩‍👧‍👧", ["@handle.com"])
        ]

        for testCase in testCases {
            let spans = ATFacetParser.parseMentions(from: testCase.input)
            #expect(spans.map(\.mention) == testCase.mentions)
            #expect(spans.map { ByteRange(byteStart: $0.byteStart, byteEnd: $0.byteEnd) } == expectedByteRanges(for: testCase.mentions, in: testCase.input))
        }
    }

    @Test("Links are detected with Bluesky rich text rules")
    func detectsLinksInline() {
        let testCases: [(input: String, links: [LinkExpectation])] = [
            ("start https://middle.com end", [.init(text: "https://middle.com", uri: "https://middle.com")]),
            ("start https://middle.com/foo/bar end", [.init(text: "https://middle.com/foo/bar", uri: "https://middle.com/foo/bar")]),
            ("start https://middle.com/foo/bar?baz=bux end", [.init(text: "https://middle.com/foo/bar?baz=bux", uri: "https://middle.com/foo/bar?baz=bux")]),
            ("start https://middle.com/foo/bar?baz=bux#hash end", [.init(text: "https://middle.com/foo/bar?baz=bux#hash", uri: "https://middle.com/foo/bar?baz=bux#hash")]),
            ("https://start.com/foo/bar?baz=bux#hash middle end", [.init(text: "https://start.com/foo/bar?baz=bux#hash", uri: "https://start.com/foo/bar?baz=bux#hash")]),
            ("start middle https://end.com/foo/bar?baz=bux#hash", [.init(text: "https://end.com/foo/bar?baz=bux#hash", uri: "https://end.com/foo/bar?baz=bux#hash")]),
            ("https://newline1.com\nhttps://newline2.com", [.init(text: "https://newline1.com", uri: "https://newline1.com"), .init(text: "https://newline2.com", uri: "https://newline2.com")]),
            ("👨‍👩‍👧‍👧 https://middle.com 👨‍👩‍👧‍👧", [.init(text: "https://middle.com", uri: "https://middle.com")]),
            ("start middle.com end", [.init(text: "middle.com", uri: "https://middle.com")]),
            ("start middle.com/foo/bar end", [.init(text: "middle.com/foo/bar", uri: "https://middle.com/foo/bar")]),
            ("start middle.com/foo/bar?baz=bux end", [.init(text: "middle.com/foo/bar?baz=bux", uri: "https://middle.com/foo/bar?baz=bux")]),
            ("start middle.com/foo/bar?baz=bux#hash end", [.init(text: "middle.com/foo/bar?baz=bux#hash", uri: "https://middle.com/foo/bar?baz=bux#hash")]),
            ("start.com/foo/bar?baz=bux#hash middle end", [.init(text: "start.com/foo/bar?baz=bux#hash", uri: "https://start.com/foo/bar?baz=bux#hash")]),
            ("start middle end.com/foo/bar?baz=bux#hash", [.init(text: "end.com/foo/bar?baz=bux#hash", uri: "https://end.com/foo/bar?baz=bux#hash")]),
            ("newline1.com\nnewline2.com", [.init(text: "newline1.com", uri: "https://newline1.com"), .init(text: "newline2.com", uri: "https://newline2.com")]),
            ("a example.com/index.php php link", [.init(text: "example.com/index.php", uri: "https://example.com/index.php")]),
            ("a trailing bsky.app: colon", [.init(text: "bsky.app", uri: "https://bsky.app")]),
            ("not.. a..url ..here", []),
            ("e.g.", []),
            ("something-cool.jpg", []),
            ("website.com.jpg", []),
            ("e.g./foo", []),
            ("website.com.jpg/foo", []),
            ("Classic article https://socket3.wordpress.com/2018/02/03/designing-windows-95s-user-interface/", [.init(text: "https://socket3.wordpress.com/2018/02/03/designing-windows-95s-user-interface/", uri: "https://socket3.wordpress.com/2018/02/03/designing-windows-95s-user-interface/")]),
            ("Classic article https://socket3.wordpress.com/2018/02/03/designing-windows-95s-user-interface/ ", [.init(text: "https://socket3.wordpress.com/2018/02/03/designing-windows-95s-user-interface/", uri: "https://socket3.wordpress.com/2018/02/03/designing-windows-95s-user-interface/")]),
            ("https://foo.com https://bar.com/whatever https://baz.com", [.init(text: "https://foo.com", uri: "https://foo.com"), .init(text: "https://bar.com/whatever", uri: "https://bar.com/whatever"), .init(text: "https://baz.com", uri: "https://baz.com")]),
            ("punctuation https://foo.com, https://bar.com/whatever; https://baz.com.", [.init(text: "https://foo.com", uri: "https://foo.com"), .init(text: "https://bar.com/whatever", uri: "https://bar.com/whatever"), .init(text: "https://baz.com", uri: "https://baz.com")]),
            ("parenthentical (https://foo.com)", [.init(text: "https://foo.com", uri: "https://foo.com")]),
            ("except for https://foo.com/thing_(cool)", [.init(text: "https://foo.com/thing_(cool)", uri: "https://foo.com/thing_(cool)")])
        ]

        for testCase in testCases {
            let spans = ATFacetParser.parseURLs(from: testCase.input)
            #expect(spans.map { LinkExpectation(text: $0.link, uri: $0.uri) } == testCase.links)
            #expect(spans.map { ByteRange(byteStart: $0.byteStart, byteEnd: $0.byteEnd) } == expectedByteRanges(for: testCase.links.map(\.text), in: testCase.input))
        }
    }

    @Test("Hashtags are detected with Bluesky rich text rules")
    func detectsHashtagsInline() {
        let testCases: [(input: String, tags: [String], byteRanges: [ByteRange])] = [
            ("#a", ["a"], [.init(byteStart: 0, byteEnd: 2)]),
            ("#a #b", ["a", "b"], [.init(byteStart: 0, byteEnd: 2), .init(byteStart: 3, byteEnd: 5)]),
            ("#1", [], []),
            ("#1a", ["1a"], [.init(byteStart: 0, byteEnd: 3)]),
            ("#tag", ["tag"], [.init(byteStart: 0, byteEnd: 4)]),
            ("body #tag", ["tag"], [.init(byteStart: 5, byteEnd: 9)]),
            ("#tag body", ["tag"], [.init(byteStart: 0, byteEnd: 4)]),
            ("body #tag body", ["tag"], [.init(byteStart: 5, byteEnd: 9)]),
            ("body #1", [], []),
            ("body #1a", ["1a"], [.init(byteStart: 5, byteEnd: 8)]),
            ("body #a1", ["a1"], [.init(byteStart: 5, byteEnd: 8)]),
            ("#", [], []),
            ("#?", [], []),
            ("text #", [], []),
            ("text # text", [], []),
            ("body #thisisa64characterstring_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", ["thisisa64characterstring_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"], [.init(byteStart: 5, byteEnd: 70)]),
            ("body #thisisa65characterstring_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab", [], []),
            ("body #thisisa64characterstring_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!", ["thisisa64characterstring_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"], [.init(byteStart: 5, byteEnd: 70)]),
            ("its a #double#rainbow", ["double#rainbow"], [.init(byteStart: 6, byteEnd: 21)]),
            ("##hashash", ["#hashash"], [.init(byteStart: 0, byteEnd: 9)]),
            ("##", [], []),
            ("some #n0n3s@n5e!", ["n0n3s@n5e"], [.init(byteStart: 5, byteEnd: 15)]),
            ("works #with,punctuation", ["with,punctuation"], [.init(byteStart: 6, byteEnd: 23)]),
            ("strips trailing #punctuation, #like. #this!", ["punctuation", "like", "this"], [.init(byteStart: 16, byteEnd: 28), .init(byteStart: 30, byteEnd: 35), .init(byteStart: 37, byteEnd: 42)]),
            ("strips #multi_trailing___...", ["multi_trailing"], [.init(byteStart: 7, byteEnd: 22)]),
            ("works with #🦋 emoji, and #butter🦋fly", ["🦋", "butter🦋fly"], [.init(byteStart: 11, byteEnd: 16), .init(byteStart: 28, byteEnd: 42)]),
            ("#same #same #but #diff", ["same", "same", "but", "diff"], [.init(byteStart: 0, byteEnd: 5), .init(byteStart: 6, byteEnd: 11), .init(byteStart: 12, byteEnd: 16), .init(byteStart: 17, byteEnd: 22)]),
            ("this #️⃣tag should not be a tag", [], []),
            ("this ##️⃣tag should be a tag", ["#️⃣tag"], [.init(byteStart: 5, byteEnd: 16)]),
            ("this #t\nag should be a tag", ["t"], [.init(byteStart: 5, byteEnd: 7)]),
            ("no match (\\u200B): #​", [], []),
            ("no match (\\u200Ba): #​a", [], []),
            ("match (a\\u200Bb): #a​b", ["a"], [.init(byteStart: 18, byteEnd: 20)]),
            ("match (ab\\u200B): #ab​", ["ab"], [.init(byteStart: 18, byteEnd: 21)]),
            ("no match (\\u20e2tag): #⃢tag", [], []),
            ("no match (a\\u20e2b): #a⃢b", ["a"], [.init(byteStart: 21, byteEnd: 23)]),
            ("match full width number sign (tag): ＃tag", ["tag"], [.init(byteStart: 36, byteEnd: 42)]),
            ("match full width number sign (tag): ＃#️⃣tag", ["#️⃣tag"], [.init(byteStart: 36, byteEnd: 49)]),
            ("no match 1?: #1?", [], [])
        ]

        for testCase in testCases {
            let spans = ATFacetParser.parseHashtags(from: testCase.input)
            #expect(spans.map { String($0.tag.dropFirst()) } == testCase.tags)
            #expect(spans.map { ByteRange(byteStart: $0.byteStart, byteEnd: $0.byteEnd) } == testCase.byteRanges)
        }
    }

    @Test("Cashtags are detected with Bluesky rich text rules")
    func detectsCashtagsInline() async {
        let testCases: [(input: String, tags: [String], byteRanges: [AppBskyLexicon.RichText.Facet.ByteSlice])] = [
            ("$AAPL", ["$AAPL"], [.init(byteStart: 0, byteEnd: 5)]),
            ("$aapl", ["$AAPL"], [.init(byteStart: 0, byteEnd: 5)]),
            ("$A", ["$A"], [.init(byteStart: 0, byteEnd: 2)]),
            ("$a", ["$A"], [.init(byteStart: 0, byteEnd: 2)]),
            (
                "$BTC $ETH",
                ["$BTC", "$ETH"],
                [.init(byteStart: 0, byteEnd: 4), .init(byteStart: 5, byteEnd: 9)]
            ),
            ("$100", [], []),
            ("$GOOGL", ["$GOOGL"], [.init(byteStart: 0, byteEnd: 6)]),
            ("$TOOLONG", [], []),
            ("check $LEGO now", ["$LEGO"], [.init(byteStart: 6, byteEnd: 11)]),
            ("($GOOG)", ["$GOOG"], [.init(byteStart: 1, byteEnd: 6)]),
            ("$AAPL.", ["$AAPL"], [.init(byteStart: 0, byteEnd: 5)]),
            (
                "$AAPL, $MSFT!",
                ["$AAPL", "$MSFT"],
                [.init(byteStart: 0, byteEnd: 5), .init(byteStart: 7, byteEnd: 12)]
            ),
            ("no$SPACE", [], []),
            ("$", [], []),
            ("$ AAPL", [], []),
            ("$123ABC", [], []),
            ("$ABC12", ["$ABC12"], [.init(byteStart: 0, byteEnd: 6)]),
            ("$ABC123", [], [])
        ]

        for testCase in testCases {
            let spans = ATFacetParser.parseCashtags(from: testCase.input)
            #expect(spans.map(\.tag) == testCase.tags)
            #expect(spans.map { AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: $0.byteStart, byteEnd: $0.byteEnd) } == testCase.byteRanges)

            let facets = await ATFacetParser.parseFacets(from: testCase.input)
            let cashtagFacets = facets.filter { facet in
                facet.features.contains { feature in
                    if case .tag(let tag) = feature {
                        return tag.tag.hasPrefix("$")
                    }
                    return false
                }
            }

            let facetTags = cashtagFacets.compactMap { facet in
                facet.features.compactMap { feature in
                    if case .tag(let tag) = feature {
                        return tag.tag
                    }
                    return nil
                }.first
            }

            #expect(facetTags == testCase.tags)
            #expect(cashtagFacets.map(\.index) == testCase.byteRanges)
        }
    }

    #if canImport(Darwin)
    @Test("AttributedString facet index converts UTF-8 byte slices")
    @available(iOS 15, tvOS 15, macOS 12, watchOS 8, *)
    func attributedStringFacetIndexConvertsUTF8ByteSlices() throws {
        let text = "👨‍👩‍👧‍👧 https://middle.com tail"
        let attributedString = AttributedString(text)
        let span = try #require(ATFacetParser.parseURLs(from: text).first)
        let byteSlice = AppBskyLexicon.RichText.Facet.ByteSlice(
            byteStart: span.byteStart,
            byteEnd: span.byteEnd
        )

        let range = try #require(attributedString.facetIndex(from: byteSlice))
        #expect(String(attributedString[range].characters) == "https://middle.com")
    }

    @Test("NSAttributedString facet range converts UTF-8 byte slices")
    func nsAttributedStringFacetRangeConvertsUTF8ByteSlices() throws {
        let text = "👨‍👩‍👧‍👧 https://middle.com tail"
        let attributedString = NSAttributedString(string: text)
        let span = try #require(ATFacetParser.parseURLs(from: text).first)
        let byteSlice = AppBskyLexicon.RichText.Facet.ByteSlice(
            byteStart: span.byteStart,
            byteEnd: span.byteEnd
        )

        let range = try #require(attributedString.facetRange(from: byteSlice))
        #expect(attributedString.attributedSubstring(from: range).string == "https://middle.com")
    }
    #endif

    private func expectedByteRanges(for matches: [String], in text: String) -> [ByteRange] {
        var ranges = [ByteRange]()
        var searchStart = text.startIndex

        for match in matches {
            guard let range = text.range(of: match, range: searchStart..<text.endIndex) else {
                continue
            }

            let byteStart = text.utf8.distance(from: text.utf8.startIndex, to: range.lowerBound.samePosition(in: text.utf8) ?? text.utf8.startIndex)
            let byteEnd = text.utf8.distance(from: text.utf8.startIndex, to: range.upperBound.samePosition(in: text.utf8) ?? text.utf8.startIndex)
            ranges.append(ByteRange(byteStart: byteStart, byteEnd: byteEnd))
            searchStart = range.upperBound
        }

        return ranges
    }
}
