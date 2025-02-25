//
//  ATFacetParser.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

/// A utility class designed for parsing various elements like mentions, URLs, and hashtags from text.
public class ATFacetParser {

    /// Parses mentions from a given text and returns them along with their positions.
    ///
    /// - Parameter text: The text to parse for mentions.
    /// - Returns: An array of `Dictionary`s containing the start and end positions of each mention
    /// and the mention text.
    public static func parseMentions(from text: String) -> [[String: Any]] {
        var spans = [[String: Any]]()

        // Regex for grabbing @mentions based on Bluesky's regex.
        let mentionRegex = "[\\s|^](@([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)"

        do {
            let regex = try NSRegularExpression(pattern: mentionRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match else { return }

                let nsRange = match.range(at: 1)
                if let range = Range(nsRange, in: text) {
                    if let lowerBound = range.lowerBound.samePosition(in: text.utf8),
                       let upperBound = range.upperBound.samePosition(in: text.utf8) {

                        let utf8Start = text.utf8.distance(from: text.utf8.startIndex, to: lowerBound)
                        let utf8End = text.utf8.distance(from: text.utf8.startIndex, to: upperBound)

                        let mentionText = String(text[range])

                        spans.append([
                            "start": utf8Start,
                            "end": utf8End,
                            "mention": mentionText
                        ])
                    }
                }
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return spans
    }

    /// Parses URLs from a given text and returns them along with their positions.
    ///
    /// - Parameter text: The text to parse for URLs.
    /// - Returns: An array of `Dictionary`s containing the start and end positions of each URL and
    /// the URL text.
    public static func parseURLs(from text: String) -> [[String: Any]] {
        var spans = [[String: Any]]()

        // Regular expression pattern for identifying URLs.
        let linkRegex = "[\\s|^](https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*[-a-zA-Z0-9@%_\\+~#//=])?)"

        do {
            let regex = try NSRegularExpression(pattern: linkRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match else { return }

                let nsRange = match.range(at: 1)
                if let range = Range(nsRange, in: text) {
                    if let lowerBound = range.lowerBound.samePosition(in: text.utf8),
                       let upperBound = range.upperBound.samePosition(in: text.utf8) {

                        let utf8Start = text.utf8.distance(from: text.utf8.startIndex, to: lowerBound)
                        let utf8End = text.utf8.distance(from: text.utf8.startIndex, to: upperBound)

                        let linkText = String(text[range])

                        spans.append([
                            "start": utf8Start,
                            "end": utf8End,
                            "link": linkText
                        ])
                    }
                }
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return spans
    }

    /// Parses hashtags from a given text and returns them along with their positions.
    ///
    /// - Parameter text: The text to parse for hashtags.
    /// - Returns: An array of `Dictionary`s containing the start and end positions of each
    /// hashtag and the hashtag text.
    public static func parseHashtags(from text: String) -> [[String: Any]] {
        var spans = [[String: Any]]()

        // Regex pattern for identifying hashtags.
        let hashtagRegex = "(?<!\\w)(#[\\p{L}\\p{M}\\p{N}_]+)"

        do {
            let regex = try NSRegularExpression(pattern: hashtagRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match else { return }

                let nsRange = match.range(at: 1)
                if let range = Range(nsRange, in: text) {
                    if let lowerBound = range.lowerBound.samePosition(in: text.utf8),
                       let upperBound = range.upperBound.samePosition(in: text.utf8) {
                        
                        let utf8Start = text.utf8.distance(from: text.utf8.startIndex, to: lowerBound)
                        let utf8End = text.utf8.distance(from: text.utf8.startIndex, to: upperBound)
                        
                        let hashtagText = String(text[range])
                        
                        spans.append([
                            "start": utf8Start,
                            "end": utf8End,
                            "tag": hashtagText
                        ])
                    }
                }
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return spans
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

    /// Processes text to find mentions, URLs, and hashtags, converting these elements into
    /// ``AppBskyLexicon/RichText/Facet`` objects.
    ///
    /// - Parameters:
    ///   - text: The text to be processed.
    ///   - pdsURL: The URL of the Personal Data Server, defaulting to "https://bsky.social".
    /// - Returns: An array of ``AppBskyLexicon/RichText/Facet`` objects representing the structured data elements found
    /// in the text.
    public static func parseFacets(from text: String, pdsURL: String = "https://bsky.social") async -> [AppBskyLexicon.RichText.Facet] {
        // Results for mentions, URLs, and hashtags
        async let mentionFacets = parseMentionFacets(from: text, pdsURL: pdsURL)
        async let urlFacets = parseURLFacets(from: text)
        async let hashtagFacets = parseHashtagFacets(from: text)

        // Await and combine results
        let allFacets = await (mentionFacets + urlFacets + hashtagFacets)
        return allFacets
    }

    private static func parseMentionFacets(from text: String, pdsURL: String) async -> [AppBskyLexicon.RichText.Facet] {
        var facets = [AppBskyLexicon.RichText.Facet]()

        for mention in parseMentions(from: text) {
            do {
                // Unless something is wrong with `parseMentions()`, this is unlikely to fail.
                guard let handle = mention["mention"] as? String else { continue }
                print("Mention text: \(handle)")

                // Remove the `@` from the handle.
                let notATHandle = String(handle.dropFirst())

                let mentionResult = try await ATProtoKit(pdsURL: pdsURL, canUseBlueskyRecords: false).resolveHandle(from: notATHandle)

                guard let start = mention["start"] as? Int, let end = mention["end"] as? Int else { continue }

                facets.append(AppBskyLexicon.RichText.Facet(
                    index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
                    features: [.mention(AppBskyLexicon.RichText.Facet.Mention(did: mentionResult.did))]
                ))
            } catch {
                print("Error resolving mention: \(error)")
            }
        }
        return facets
    }

    private static func parseURLFacets(from text: String) async -> [AppBskyLexicon.RichText.Facet] {
        var facets = [AppBskyLexicon.RichText.Facet]()

        for link in parseURLs(from: text) {
            // Unless something is wrong with `parseURLs()`, this is unlikely to fail.
            guard let url = link["link"] as? String,
                  let start = link["start"] as? Int,
                  let end = link["end"] as? Int else { continue }
            print("URL: \(link)")

            facets.append(AppBskyLexicon.RichText.Facet(
                index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
                features: [.link(AppBskyLexicon.RichText.Facet.Link(uri: url))]
            ))
        }
        return facets
    }

    private static func parseHashtagFacets(from text: String) async -> [AppBskyLexicon.RichText.Facet] {
        var facets = [AppBskyLexicon.RichText.Facet]()

        for hashtag in parseHashtags(from: text) {
            // Unless something is wrong with `parseHashtags()`, this is unlikely to fail.
            guard let tag = hashtag["tag"] as? String,
                  let start = hashtag["start"] as? Int,
                  let end = hashtag["end"] as? Int else { continue }

            // rid us of this meddlesome "#" character
            let unhashedTag = String(tag.dropFirst())
            print("Hashtag: \(unhashedTag)")

            facets.append(AppBskyLexicon.RichText.Facet(
                index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
                features: [.tag(AppBskyLexicon.RichText.Facet.Tag(tag: unhashedTag))]
            ))
        }
        return facets
    }

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

