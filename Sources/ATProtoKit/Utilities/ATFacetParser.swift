//
//  ATFacetParser.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

/// A utility class designed for parsing various elements like mentions, URLs, and hashtags from text.
public class ATFacetParser {

    /// Manages a collection of ``AppBskyLexicon/RichText/Facet`` objects, providing thread-safe append operations.
    actor FacetsActor {

        /// The collection of ``AppBskyLexicon/RichText/Facet`` objects.
        var facets = [AppBskyLexicon.RichText.Facet]()

        /// Appends a new ``AppBskyLexicon/RichText/Facet`` to the collection in a thread-safe manner.
        /// - Parameter facet: Parameter facet: The ``AppBskyLexicon/RichText/Facet`` to append.
        func append(_ facet: AppBskyLexicon.RichText.Facet) {
            facets.append(facet)
        }
    }

    /// Parses mentions from a given text and returns them along with their positions.
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

    /// Processes text to find mentions, URLs, and hashtags, converting these elements into
    /// ``AppBskyLexicon/RichText/Facet`` objects.
    /// - Parameters:
    ///   - text: The text to be processed.
    ///   - pdsURL: The URL of the Personal Data Server, defaulting to "https://bsky.social".
    /// - Returns: An array of ``AppBskyLexicon/RichText/Facet`` objects representing the structured data elements found
    /// in the text.
    public static func parseFacets(from text: String, pdsURL: String = "https://bsky.social") async -> [AppBskyLexicon.RichText.Facet] {
        let facets = FacetsActor()

        await withTaskGroup(of: Void.self) { group in
            for mention in self.parseMentions(from: text) {
                group.addTask {
                    do {
                        // Unless something is wrong with `parseMentions()`, this is unlikely to fail.
                        guard let handle = mention["mention"] as? String else { return }
                        print("Mention text: \(handle)")

                        // Remove the `@` from the handle.
                        let notATHandle = String(handle.dropFirst())

                        let mentionResult = try await ATProtoKit().resolveHandle(from: notATHandle, pdsURL: pdsURL)

                        guard let start = mention["start"] as? Int, let end = mention["end"] as? Int else { return }

                        let mentionFacet = AppBskyLexicon.RichText.Facet(
                            index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
                            features: [.mention(AppBskyLexicon.RichText.Facet.Mention(did: mentionResult.did))])

                        await facets.append(mentionFacet)
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }

            // Grab all of the URLs and add them to the facet.
            for link in self.parseURLs(from: text) {
                group.addTask {
                    // Unless something is wrong with `parseURLs()`, this is unlikely to fail.
                    guard let url = link["link"] as? String else { return }
                    print("URL: \(link)")

                    if let start = link["start"] as? Int,
                       let end = link["end"] as? Int {
                        let linkFacet = AppBskyLexicon.RichText.Facet(
                            index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
                            features: [.link(AppBskyLexicon.RichText.Facet.Link(uri: url))]
                        )

                        await facets.append(linkFacet)
                    }
                }
            }

            // Grab all of the hashtags and add them to the facet.
            for hashtag in self.parseHashtags(from: text) {
                group.addTask {
                    // Unless something is wrong with `parseHashtags()`, this is unlikely to fail.
                    guard let tag = hashtag["tag"] as? String else { return }
                    // rid us of this meddlesome "#" character
                    let unhashedTag = String(tag.dropFirst())
                    print("Hashtag: \(unhashedTag)")

                    if let start = hashtag["start"] as? Int,
                       let end = hashtag["end"] as? Int {
                        let hashTagFacet = AppBskyLexicon.RichText.Facet(
                            index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
                            features: [.tag(AppBskyLexicon.RichText.Facet.Tag(tag: unhashedTag))]
                        )

                        await facets.append(hashTagFacet)
                    }
                }
            }
        }

        return await facets.facets
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
