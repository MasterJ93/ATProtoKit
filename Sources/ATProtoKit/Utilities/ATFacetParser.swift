//
//  ATFacetParser.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A utility class designed for parsing various elements like mentions, URLs, and hashtags
/// from text.
///
/// This is a robust, extensible utility for parsing, identifying, and structuring rich text
/// facets (mentions, URLs, and hashtags) from Bluesky content. This type provides static methods
/// to extract these entities, annotate their locations in UTF-8 byte offsets, and convert them
/// into strongly-typed ``AppBskyLexicon/RichText/Facet`` models suitable for rendering, rich-text
/// editing, and transforming them to interactable links.
public enum ATFacetParser {

    /// A byte range and mention text found in rich text.
    public struct MentionSpan: Sendable, Equatable, Hashable {

        /// The mention's start offset in UTF-8 bytes.
        public let byteStart: Int

        /// The mention's end offset in UTF-8 bytes.
        public let byteEnd: Int

        /// The mention text, including the `@` prefix.
        public let mention: String

        /// Creates a mention span.
        ///
        /// - Parameters:
        ///   - byteStart: The mention's start offset in UTF-8 bytes.
        ///   - byteEnd: The mention's end offset in UTF-8 bytes.
        ///   - mention: The mention text, including the `@` prefix.
        public init(byteStart: Int, byteEnd: Int, mention: String) {
            self.byteStart = byteStart
            self.byteEnd = byteEnd
            self.mention = mention
        }
    }

    /// A byte range and link text found in rich text.
    public struct LinkSpan: Sendable, Equatable, Hashable {

        /// The link's start offset in UTF-8 bytes.
        public let byteStart: Int

        /// The link's end offset in UTF-8 bytes.
        public let byteEnd: Int

        /// The link text.
        public let link: String

        /// The URI represented by the link.
        public let uri: String

        /// Creates a link span.
        ///
        /// - Parameters:
        ///   - byteStart: The link's start offset in UTF-8 bytes.
        ///   - byteEnd: The link's end offset in UTF-8 bytes.
        ///   - link: The link text.
        ///   - uri: The URI represented by the link.
        public init(byteStart: Int, byteEnd: Int, link: String, uri: String? = nil) {
            self.byteStart = byteStart
            self.byteEnd = byteEnd
            self.link = link
            self.uri = uri ?? link
        }
    }

    /// A byte range and hashtag text found in rich text.
    public struct HashtagSpan: Sendable, Equatable, Hashable {

        /// The hashtag's start offset in UTF-8 bytes.
        public let byteStart: Int

        /// The hashtag's end offset in UTF-8 bytes.
        public let byteEnd: Int

        /// The hashtag text, including the `#` prefix.
        public let tag: String

        /// Creates a hashtag span.
        ///
        /// - Parameters:
        ///   - byteStart: The hashtag's start offset in UTF-8 bytes.
        ///   - byteEnd: The hashtag's end offset in UTF-8 bytes.
        ///   - tag: The hashtag text, including the `#` prefix.
        public init(byteStart: Int, byteEnd: Int, tag: String) {
            self.byteStart = byteStart
            self.byteEnd = byteEnd
            self.tag = tag
        }
    }

    /// A byte range and cashtag text found in rich text.
    public struct CashtagSpan: Sendable, Equatable, Hashable {

        /// The cashtag's start offset in UTF-8 bytes.
        public let byteStart: Int

        /// The cashtag's end offset in UTF-8 bytes.
        public let byteEnd: Int

        /// The normalized cashtag text, including the `$` prefix.
        public let tag: String

        /// Creates a cashtag span.
        ///
        /// - Parameters:
        ///   - byteStart: The cashtag's start offset in UTF-8 bytes.
        ///   - byteEnd: The cashtag's end offset in UTF-8 bytes.
        ///   - tag: The normalized cashtag text, including the `$` prefix.
        public init(byteStart: Int, byteEnd: Int, tag: String) {
            self.byteStart = byteStart
            self.byteEnd = byteEnd
            self.tag = tag
        }
    }

    /// A regular expression related to identifying @mentions.
    ///
    /// Based on Bluesky's regular expression.
    internal static let mentionRegex = #"(^|\s|\()(@)([a-zA-Z0-9.-]+)(\b)"#

    /// A regular expression related to identifying links.
    internal static let linkRegex = #"(^|\s|\()((https?://\S+)|(([a-z][a-z0-9]*(\.[a-z0-9]+)+)\S*))"#

    /// A regular expression related to identifying hashtags.
    internal static let hashtagRegex = #"(^|\s)[#\x{FF03}]((?!\x{FE0F})[^\s\x{00AD}\x{2060}\x{200A}\x{200B}\x{200C}\x{200D}\x{20E2}]*[^\d\s\p{P}\x{00AD}\x{2060}\x{200A}\x{200B}\x{200C}\x{200D}\x{20E2}]+[^\s\x{00AD}\x{2060}\x{200A}\x{200B}\x{200C}\x{200D}\x{20E2}]*)?"#

    /// A regular expression related to identifying cashtags.
    internal static let cashtagRegex = #"(^|\s|\()\$([A-Za-z][A-Za-z0-9]{0,4})(?=\s|$|[.,;:!?)"'\x{2019}])"#

    /// Parses mentions from a given text and returns them along with their positions.
    ///
    /// - Parameter text: The text to parse for mentions.
    /// - Returns: An array of mention spans.
    public static func parseMentions(from text: String) -> [MentionSpan] {
        var spans = [MentionSpan]()

        do {
            let regex = try NSRegularExpression(pattern: Self.mentionRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match else { return }

                guard let handleRange = Range(match.range(at: 3), in: text),
                      Self.isValidDomain(String(text[handleRange]), allowsTestDomain: true),
                      let prefixRange = Range(match.range(at: 2), in: text) else { return }

                let range = prefixRange.lowerBound..<handleRange.upperBound
                guard let byteRange = byteRange(in: text, for: range) else { return }

                let mentionText = String(text[range])
                spans.append(MentionSpan(
                    byteStart: byteRange.start,
                    byteEnd: byteRange.end,
                    mention: mentionText
                ))
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return spans
    }

    /// Parses URLs from a given text and returns them along with their positions.
    ///
    /// - Parameter text: The text to parse for URLs.
    /// - Returns: An array of link spans.
    public static func parseURLs(from text: String) -> [LinkSpan] {
        var spans = [LinkSpan]()

        do {
            let regex = try NSRegularExpression(pattern: Self.linkRegex, options: [.caseInsensitive])
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match else { return }

                guard let linkRange = Range(match.range(at: 2), in: text) else { return }

                var uri = String(text[linkRange])
                if uri.hasPrefix("http") == false {
                    guard let domainRange = Range(match.range(at: 5), in: text),
                          Self.isValidDomain(String(text[domainRange]), allowsTestDomain: false) else { return }

                    uri = "https://\(uri)"
                }

                var adjustedLinkRange = linkRange
                while let lastCharacter = uri.last,
                      ".,;:!?".contains(lastCharacter) {
                    uri.removeLast()
                    adjustedLinkRange = adjustedLinkRange.lowerBound..<text.index(before: adjustedLinkRange.upperBound)
                }

                if uri.hasSuffix(")") && uri.contains("(") == false {
                    uri.removeLast()
                    adjustedLinkRange = adjustedLinkRange.lowerBound..<text.index(before: adjustedLinkRange.upperBound)
                }

                guard let byteRange = byteRange(in: text, for: adjustedLinkRange) else { return }

                let linkText = String(text[adjustedLinkRange])
                spans.append(LinkSpan(
                    byteStart: byteRange.start,
                    byteEnd: byteRange.end,
                    link: linkText,
                    uri: uri
                ))
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return spans
    }

    /// Parses hashtags from a given text and returns them along with their positions.
    ///
    /// - Parameter text: The text to parse for hashtags.
    /// - Returns: An array of hashtag spans.
    public static func parseHashtags(from text: String) -> [HashtagSpan] {
        var spans = [HashtagSpan]()

        do {
            let regex = try NSRegularExpression(pattern: hashtagRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match,
                      let leadingRange = Range(match.range(at: 1), in: text),
                      let tagRange = Range(match.range(at: 2), in: text) else { return }

                let tagText = Self.trimmingTrailingPunctuation(
                    from: Self.trimmingForbiddenTagScalars(
                        from: String(text[tagRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                )
                guard tagText.isEmpty == false,
                      tagText.count <= 64 else { return }

                guard let lowerBound = leadingRange.upperBound.samePosition(in: text.utf8) else { return }

                let markerRange = leadingRange.upperBound..<tagRange.lowerBound
                let markerText = String(text[markerRange])
                let byteStart = text.utf8.distance(from: text.utf8.startIndex, to: lowerBound)
                spans.append(HashtagSpan(
                    byteStart: byteStart,
                    byteEnd: byteStart + markerText.utf8.count + tagText.utf8.count,
                    tag: "#\(tagText)"
                ))
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return spans
    }

    /// Parses cashtags from a given text and returns them along with their positions.
    ///
    /// - Parameter text: The text to parse for cashtags.
    /// - Returns: An array of cashtag spans.
    public static func parseCashtags(from text: String) -> [CashtagSpan] {
        var spans = [CashtagSpan]()

        do {
            let regex = try NSRegularExpression(pattern: Self.cashtagRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match,
                      let matchedRange = Range(match.range(at: 0), in: text),
                      let leadingRange = Range(match.range(at: 1), in: text),
                      let tickerRange = Range(match.range(at: 2), in: text) else { return }

                let cashtagRange = leadingRange.upperBound..<tickerRange.upperBound
                guard matchedRange.contains(cashtagRange.lowerBound),
                      let byteRange = byteRange(in: text, for: cashtagRange) else { return }

                let ticker = String(text[tickerRange]).uppercased()
                spans.append(CashtagSpan(
                    byteStart: byteRange.start,
                    byteEnd: byteRange.end,
                    tag: "$\(ticker)"
                ))
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return spans
    }
    
    /// Replaces URL text in the original string with a truncated version used for display in Bluesky.
    /// 
    /// - Parameter text: The post's text.
    /// - Returns: A tuple containing the updated plain text and an array of link facets.
    ///   Each link facet represents a detected URL within the text, along with its start and end positions.
    public static func truncateAndReplaceLinks(in text: String) -> (text: String, updatedLinkFacets: [(url: URL, start: Int, end: Int)]) {
        var result = ""
        var updatedFacets: [(url: URL, start: Int, end: Int)] = []
        var currentByteOffset = 0
        var lastByteIndex = text.utf8.startIndex
        
        let urls = parseURLs(from: text)
        
        for urlInfo in urls {
            let start = urlInfo.byteStart
            let end = urlInfo.byteEnd
            let linkString = urlInfo.uri

            guard let url = URL(string: linkString) else { continue }
            
            let utf8View = text.utf8
            guard let utf8Start = utf8View.index(utf8View.startIndex, offsetBy: start, limitedBy: utf8View.endIndex),
                  let utf8End = utf8View.index(utf8View.startIndex, offsetBy: end, limitedBy: utf8View.endIndex) else { continue }

            let unchangedRange = lastByteIndex..<utf8Start
            if let unchangedStart = String.Index(unchangedRange.lowerBound, within: text),
               let unchangedEnd = String.Index(unchangedRange.upperBound, within: text) {
                let unchangedText = text[unchangedStart..<unchangedEnd]
                result.append(contentsOf: unchangedText)
                currentByteOffset += unchangedText.utf8.count
            }
            
            let stripped = linkString.replacingOccurrences(of: #"^https?://"#, with: "", options: .regularExpression)
            let replacement: String
            if stripped.count > 32 {
                replacement = String(stripped.prefix(29)) + "..."
            } else {
                replacement = stripped
            }
            
            result.append(replacement)
            updatedFacets.append((url, currentByteOffset, currentByteOffset + replacement.utf8.count))
            currentByteOffset += replacement.utf8.count
            lastByteIndex = utf8End
        }
        
        if let tailStart = String.Index(lastByteIndex, within: text) {
            let remaining = text[tailStart...]
            result.append(contentsOf: remaining)
        }
        
        return (result, updatedFacets)
    }


    /// Creates an inline link facet for a given URL with specified start and end positions.
    ///
    /// - Parameters:
    ///   - url: The URL to link.
    ///   - start: The start position of the link in the text (byte offset).
    ///   - end: The end position of the link in the text (byte offset).
    /// - Returns: An instance of ``AppBskyLexicon/RichText/Facet``.
    ///
    /// - Throws: An `InlineLinkError` if the range or URL is invalid.
    public static func createInlineLink(url: URL, start: Int, end: Int) async throws -> AppBskyLexicon.RichText.Facet {
        guard start >= 0, end > start else {
            throw InlineLinkError.invalidRange(start: start, end: end)
        }

        guard url.scheme == "http" || url.scheme == "https" else {
            throw InlineLinkError.invalidURL(url: url)
        }

        let facet = AppBskyLexicon.RichText.Facet(
            index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
            features: [.link(AppBskyLexicon.RichText.Facet.Link(uri: url.absoluteString))]
        )

        return facet
    }

    /// Processes text to find mentions, URLs, hashtags, and cashtags, converting these elements into
    /// ``AppBskyLexicon/RichText/Facet`` objects.
    ///
    /// - Parameters:
    ///   - text: The text to be processed.
    ///   - pdsURL: The URL of the Personal Data Server, defaulting to "https://bsky.social".
    /// - Returns: An array of ``AppBskyLexicon/RichText/Facet`` objects representing the structured data elements found
    /// in the text.
    public static func parseFacets(from text: String, pdsURL: String = "https://bsky.social") async -> [AppBskyLexicon.RichText.Facet] {
        async let mentionFacets = parseMentionFacets(from: text, pdsURL: pdsURL)
        async let urlFacets = parseURLFacets(from: text)
        async let hashtagFacets = parseHashtagFacets(from: text)
        async let cashtagFacets = parseCashtagFacets(from: text)

        let allFacets = await (mentionFacets + urlFacets + hashtagFacets + cashtagFacets)
        return allFacets
    }

    /// Processes detected mentions into mention facets.
    ///
    /// - Parameters:
    ///   - text: The text to parse.
    ///   - pdsURL: The Personal Data Server URL to use when resolving handles.
    /// - Returns: An array of mention facets.
    private static func parseMentionFacets(from text: String, pdsURL: String) async -> [AppBskyLexicon.RichText.Facet] {
        var facets = [AppBskyLexicon.RichText.Facet]()

        for mention in parseMentions(from: text) {
            do {
                let handle = mention.mention
                print("Mention text: \(handle)")

                // Remove the `@` from the handle.
                let notATHandle = String(handle.dropFirst())

                let mentionResult = try await ATProtoKit(pdsURL: pdsURL, canUseBlueskyRecords: false).resolveHandle(from: notATHandle)

                facets.append(AppBskyLexicon.RichText.Facet(
                    index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: mention.byteStart, byteEnd: mention.byteEnd),
                    features: [.mention(AppBskyLexicon.RichText.Facet.Mention(did: mentionResult.did))]
                ))
            } catch {
                print("Error resolving mention: \(error)")
            }
        }
        return facets
    }

    /// Processes detected URLs into link facets.
    ///
    /// - Parameter text: The text to parse.
    /// - Returns: An array of link facets.
    private static func parseURLFacets(from text: String) async -> [AppBskyLexicon.RichText.Facet] {
        var facets = [AppBskyLexicon.RichText.Facet]()

        for link in parseURLs(from: text) {
            let url = link.uri
            print("URL: \(link)")

            facets.append(AppBskyLexicon.RichText.Facet(
                index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: link.byteStart, byteEnd: link.byteEnd),
                features: [.link(AppBskyLexicon.RichText.Facet.Link(uri: url))]
            ))
        }
        return facets
    }

    /// Processes detected hashtags into tag facets.
    ///
    /// - Parameter text: The text to parse.
    /// - Returns: An array of tag facets.
    private static func parseHashtagFacets(from text: String) async -> [AppBskyLexicon.RichText.Facet] {
        var facets = [AppBskyLexicon.RichText.Facet]()

        for hashtag in parseHashtags(from: text) {
            let unhashedTag = String(hashtag.tag.dropFirst())
            print("Hashtag: \(unhashedTag)")

            facets.append(AppBskyLexicon.RichText.Facet(
                index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: hashtag.byteStart, byteEnd: hashtag.byteEnd),
                features: [.tag(AppBskyLexicon.RichText.Facet.Tag(tag: unhashedTag))]
            ))
        }
        return facets
    }

    /// Processes detected cashtags into tag facets.
    ///
    /// - Parameter text: The text to parse.
    /// - Returns: An array of tag facets.
    private static func parseCashtagFacets(from text: String) async -> [AppBskyLexicon.RichText.Facet] {
        var facets = [AppBskyLexicon.RichText.Facet]()

        for cashtag in parseCashtags(from: text) {
            facets.append(AppBskyLexicon.RichText.Facet(
                index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: cashtag.byteStart, byteEnd: cashtag.byteEnd),
                features: [.tag(AppBskyLexicon.RichText.Facet.Tag(tag: cashtag.tag))]
            ))
        }

        return facets
    }

    /// Converts a string range to UTF-8 byte offsets.
    ///
    /// - Parameters:
    ///   - text: The text that contains the range.
    ///   - range: The string range to convert.
    /// - Returns: A tuple containing the start and end byte offsets, or `nil` when conversion fails.
    private static func byteRange(in text: String, for range: Range<String.Index>) -> (start: Int, end: Int)? {
        guard let lowerBound = range.lowerBound.samePosition(in: text.utf8),
              let upperBound = range.upperBound.samePosition(in: text.utf8) else {
            return nil
        }

        let utf8Start = text.utf8.distance(from: text.utf8.startIndex, to: lowerBound)
        let utf8End = text.utf8.distance(from: text.utf8.startIndex, to: upperBound)

        return (utf8Start, utf8End)
    }

    /// Indicates whether a domain has a valid top-level domain.
    ///
    /// - Parameters:
    ///   - domain: The domain to validate.
    ///   - allowsTestDomain: Indicates whether the reserved `.test` top-level domain is accepted.
    /// - Returns: `true` when the domain has an accepted top-level domain; otherwise, `false`.
    private static func isValidDomain(_ domain: String, allowsTestDomain: Bool) -> Bool {
        let lowercasedDomain = domain.lowercased()
        if allowsTestDomain && lowercasedDomain.hasSuffix(".test") {
            return true
        }

        guard let topLevelDomain = lowercasedDomain.split(separator: ".").last else {
            return false
        }

        let topLevelDomainText = String(topLevelDomain)
        guard topLevelDomainText.count >= 2,
              topLevelDomainText.allSatisfy({ $0.isLetter }),
              Self.invalidLinkTopLevelDomains.contains(topLevelDomainText) == false else {
            return false
        }

        return true
    }

    /// Removes punctuation from the end of a tag.
    ///
    /// - Parameter text: The tag text to trim.
    /// - Returns: The tag text without trailing punctuation.
    private static func trimmingTrailingPunctuation(from text: String) -> String {
        var result = text
        while let lastCharacter = result.last,
              lastCharacter.unicodeScalars.allSatisfy({ Self.isPunctuation($0) }) {
            result.removeLast()
        }

        return result
    }

    /// Removes tag content at the first scalar that Bluesky excludes from hashtags.
    ///
    /// - Parameter text: The tag text to trim.
    /// - Returns: The tag text before the first excluded scalar.
    private static func trimmingForbiddenTagScalars(from text: String) -> String {
        var scalars = String.UnicodeScalarView()

        for scalar in text.unicodeScalars {
            if Self.forbiddenTagScalars.contains(scalar) {
                break
            }

            scalars.append(scalar)
        }

        return String(scalars)
    }

    /// Indicates whether a Unicode scalar belongs to a punctuation category.
    ///
    /// - Parameter scalar: The Unicode scalar to inspect.
    /// - Returns: `true` when the scalar is punctuation; otherwise, `false`.
    private static func isPunctuation(_ scalar: Unicode.Scalar) -> Bool {
        switch scalar.properties.generalCategory {
            case .connectorPunctuation,
                 .dashPunctuation,
                 .closePunctuation,
                 .finalPunctuation,
                 .initialPunctuation,
                 .otherPunctuation,
                 .openPunctuation:
                return true
            default:
                return false
        }
    }

    /// File extensions that are intentionally excluded from bare link detection.
    private static let invalidLinkTopLevelDomains: Set<String> = [
        "jpg"
    ]

    /// Scalars that stop Bluesky hashtag parsing.
    private static let forbiddenTagScalars: Set<Unicode.Scalar> = Set(
        [
            "\u{00AD}",
            "\u{2060}",
            "\u{200A}",
            "\u{200B}",
            "\u{200C}",
            "\u{200D}",
            "\u{20E2}"
        ].flatMap(\.unicodeScalars)
    )

    /// Errors that can occur when creating an inline link facet.
    public enum InlineLinkError: ATProtoError, LocalizedError {

        /// The start and/or end range is invalid.
        ///
        /// - Parameters:
        ///   - start: The starting index number.
        ///   - end: The ending index number.
        case invalidRange(start: Int, end: Int)

        /// The URL is invalid.
        ///
        /// - Parameter url: The specified URL.
        case invalidURL(url: URL)

        public var errorDescription: String? {
            switch self {
                case .invalidRange(let start, let end):
                    return "Invalid range: \"start\" (\(start)) must be >= 0, and \"end\" (\(end)) must be greater than \"start\"."
                case .invalidURL(let url):
                    return "Invalid URL: \(url.absoluteString). Only valid HTTP/HTTPS URLs are allowed."
            }
        }
    }
}

/// A data model protocol for Features.
///
/// - SeeAlso: This is based on the [`app.bsky.richtext.facet`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/richtext/facet.json
internal protocol FeatureCodable: Codable {

    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    static var type: String { get }
}

// MARK: AttributedString -
@available(iOS 15, tvOS 15, macOS 12, watchOS 8, *)
extension AttributedString {

    /// Converts a ``AppBskyLexicon/RichText/Facet/ByteSlice`` instance into
    /// a `Range<AttributedString.Index>`.
    ///
    /// - Parameter index: The `ByteSlice` object containing `byteStart` and `byteEnd`.
    /// - Returns: A `Range<AttributedString.Index>` if the conversion is successful, otherwise `nil`.
    func facetIndex(from index: AppBskyLexicon.RichText.Facet.ByteSlice) -> Range<AttributedString.Index>? {
        // Get the plain string representation
        let text = self.description
        let utf8View = text.utf8

        // This is based on the code written in this GitHub Issue ticket: https://github.com/MasterJ93/ATProtoKit/issues/52#issuecomment-2490853227
        guard let utf8Start = utf8View.index(utf8View.startIndex, offsetBy: index.byteStart, limitedBy: utf8View.endIndex),
              let utf8End = utf8View.index(utf8Start, offsetBy: index.byteEnd - index.byteStart, limitedBy: utf8View.endIndex),
              let stringStart = String.Index(utf8Start, within: text),
              let stringEnd = String.Index(utf8End, within: text),
              let attrStart = AttributedString.Index(stringStart, within: self),
              let attrEnd = AttributedString.Index(stringEnd, within: self) else {
            return nil
        }

        return attrStart..<attrEnd
    }
}


// MARK: NSAttributedString -
extension NSAttributedString {

    /// Converts a ``AppBskyLexicon/RichText/Facet/ByteSlice`` instance into an `NSRange`.
    ///
    /// - Parameter index: The `ByteSlice` object containing `byteStart` and `byteEnd`.
    /// - Returns: An `NSRange` if the conversion is successful, otherwise `nil`.
    func facetRange(from index: AppBskyLexicon.RichText.Facet.ByteSlice) -> NSRange? {
        // Get the plain string representation
        let text = self.string
        let utf8View = text.utf8

        // This is based on the code written in this GitHub Issue ticket: https://github.com/MasterJ93/ATProtoKit/issues/52#issuecomment-2490853227
        guard let utf8Start = utf8View.index(utf8View.startIndex, offsetBy: index.byteStart, limitedBy: utf8View.endIndex),
              let utf8End = utf8View.index(utf8Start, offsetBy: index.byteEnd - index.byteStart, limitedBy: utf8View.endIndex),
              let stringStart = String.Index(utf8Start, within: text),
              let stringEnd = String.Index(utf8End, within: text) else {
            return nil
        }

        return NSRange(stringStart..<stringEnd, in: text)
    }
}
