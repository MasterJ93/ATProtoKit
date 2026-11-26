//
//  PostFacetOffsetTests.swift
//  ATProtoKit
//
//  Created by Aaron Vegh on 2026-11-25.
//

import Foundation
import Testing
@testable import ATProtoKit

extension RegressionTests {

    /// Facets in a created post must index into the text that is actually posted.
    ///
    /// `createPostRecord` shortens long links before posting. Facets for hashtags and cashtags
    /// that appear after a shortened link were once parsed from the original text, so their byte
    /// ranges were offset by the number of bytes removed from the link and landed on the wrong text.
    @Suite("Post Facet Offset Tests")
    struct PostFacetOffsetTests {

        private static let longURL = "https://socket3.wordpress.com/2018/02/03/designing-windows-95s-user-interface/"
        private static let shortenedLongURL = "socket3.wordpress.com/2018/02..."

        /// Returns the text that a facet's byte slice covers, or `nil` when the slice is out of bounds.
        private static func text(
            for facet: AppBskyLexicon.RichText.Facet,
            in text: String
        ) -> String? {
            let bytes = Array(text.utf8)
            let start = facet.index.byteStart
            let end = facet.index.byteEnd
            guard start >= 0, end <= bytes.count, start < end else { return nil }
            return String(decoding: bytes[start..<end], as: UTF8.self)
        }

        private static func tagFacets(_ facets: [AppBskyLexicon.RichText.Facet]) -> [(tag: String, facet: AppBskyLexicon.RichText.Facet)] {
            facets.compactMap { facet in
                for feature in facet.features {
                    if case .tag(let tag) = feature { return (tag.tag, facet) }
                }
                return nil
            }
        }

        private static func linkFacets(_ facets: [AppBskyLexicon.RichText.Facet]) -> [(uri: String, facet: AppBskyLexicon.RichText.Facet)] {
            facets.compactMap { facet in
                for feature in facet.features {
                    if case .link(let link) = feature { return (link.uri, facet) }
                }
                return nil
            }
        }

        @Test("A hashtag after a shortened link indexes into the shortened text")
        func hashtagAfterShortenedLink() async throws {
            let input = "Classic article \(Self.longURL) #design"

            let (text, facets) = await ATFacetParser.buildPostFacets(from: input)

            #expect(text == "Classic article \(Self.shortenedLongURL) #design")

            let tags = Self.tagFacets(facets)
            try #require(tags.count == 1)
            #expect(tags[0].tag == "design")
            #expect(Self.text(for: tags[0].facet, in: text) == "#design")
        }

        @Test("A cashtag after a shortened link indexes into the shortened text")
        func cashtagAfterShortenedLink() async throws {
            let input = "Read \(Self.longURL) then buy $AAPL"

            let (text, facets) = await ATFacetParser.buildPostFacets(from: input)

            let tags = Self.tagFacets(facets)
            try #require(tags.count == 1)
            #expect(Self.text(for: tags[0].facet, in: text) == "$AAPL")
        }

        @Test("Tags before, between, and after several shortened links all index correctly")
        func tagsAroundMultipleShortenedLinks() async throws {
            let secondURL = "https://example.com/a/very/long/path/that/needs/to/be/shortened/for/display"
            let input = "#first \(Self.longURL) #second \(secondURL) #third"

            let (text, facets) = await ATFacetParser.buildPostFacets(from: input)

            let tags = Self.tagFacets(facets)
            #expect(tags.map(\.tag).sorted() == ["first", "second", "third"])
            for (tag, facet) in tags {
                #expect(Self.text(for: facet, in: text) == "#\(tag)")
            }
        }

        @Test("Multibyte characters before a shortened link don't shift later facets")
        func multibyteTextBeforeShortenedLink() async throws {
            let input = "👨‍👩‍👧‍👧 café \(Self.longURL) — #ünïcödé"

            let (text, facets) = await ATFacetParser.buildPostFacets(from: input)

            let tags = Self.tagFacets(facets)
            try #require(tags.count == 1)
            #expect(Self.text(for: tags[0].facet, in: text) == "#ünïcödé")
        }

        @Test("A shortened link has one link facet that covers its display text and points at the full URL")
        func shortenedLinkFacet() async throws {
            let input = "Classic article \(Self.longURL) #design"

            let (text, facets) = await ATFacetParser.buildPostFacets(from: input)

            let links = Self.linkFacets(facets)
            try #require(links.count == 1)
            #expect(links[0].uri == Self.longURL)
            #expect(Self.text(for: links[0].facet, in: text) == Self.shortenedLongURL)
        }

        @Test("Every facet in a post with shortened links stays within the posted text")
        func facetsStayInBounds() async {
            let input = "#a \(Self.longURL) #b \(Self.longURL) $TSLA #c"

            let (text, facets) = await ATFacetParser.buildPostFacets(from: input)

            #expect(!facets.isEmpty)
            for facet in facets {
                #expect(facet.index.byteEnd <= text.utf8.count)
                #expect(Self.text(for: facet, in: text) != nil)
            }
        }
    }
}
