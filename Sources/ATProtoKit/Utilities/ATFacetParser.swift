//
//  ATFacetParser.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation
import Logging

/// A utility class designed for parsing various elements like mentions, URLs, and hashtags from text.
public class ATFacetParser {
    private static var logger = Logger(label: "ATFacetParser")

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
        logger.trace("In parseMentions()")
        var spans = [[String: Any]]()

        // Regex for grabbing @mentions.
        // Based on Bluesky's regex.
        let mentionRegex = "[\\s|^](@([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)"

        do {
            logger.trace("Building regex")
            let regex = try NSRegularExpression(pattern: mentionRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            // Get the start and end positions of each match.
            logger.trace("Enumerating matches")
            regex.enumerateMatches(in: text, options: [], range: nsRange) { match, _, _ in
                guard let match = match,
                      let range = Range(match.range(at: 1), in: text) else { return }
                logger.trace("Mention has been found")

                // Text must be in a UTF-8 encoded bytestring offset.
                logger.trace("Decoding mention")
                let utf8Text = text.utf8
                let byteStart = utf8Text.distance(from: utf8Text.startIndex,
                                                  to: utf8Text.index(utf8Text.startIndex, offsetBy: text.distance(from: text.startIndex, to: range.lowerBound)))
                let byteEnd = utf8Text.distance(from: utf8Text.startIndex,
                                                to: utf8Text.index(utf8Text.startIndex, offsetBy: text.distance(from: text.startIndex, to: range.upperBound)))
                let mentionText = String(text[range])
                logger.debug("Obtained mention text", metadata: ["size": "\(mentionText.count)"])

                spans.append([
                    "start": byteStart,
                    "end": byteEnd,
                    "mention": mentionText
                ])
            }
        } catch {
            logger.error("Error while parsing mentions", metadata: ["error": "\(error.localizedDescription)"])
        }

        logger.debug("Received mentions", metadata: ["size": "\(spans.count)"])
        logger.trace("Exiting parseMentions()")
        return spans
    }

    /// Parses URLs from a given text and returns them along with their positions.
    /// - Parameter text: The text to parse for URLs.
    /// - Returns: An array of `Dictionary`s containing the start and end positions of each URL and
    /// the URL text.
    public static func parseURLs(from text: String) -> [[String: Any]] {
        logger.trace("In parseURLs()")
        var spans = [[String: Any]]()

        // Regex for grabbing links.
        // Don't know if it can get every possible link.
        // Based on the regex Bluesky grabbed.
        let linkRegex = "[\\s|^](https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*[-a-zA-Z0-9@%_\\+~#//=])?)"

        do {
            logger.trace("Building regex")
            let regex = try NSRegularExpression(pattern: linkRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            // Get the start and end positions of each match.
            logger.trace("Enumerating matches")
            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match,
                      let range = Range(match.range(at: 1), in: text) else { return }
                logger.trace("URL has been found")
                let byteStart = text.distance(from: text.startIndex, to: range.lowerBound)
                let byteEnd = text.distance(from: text.startIndex, to: range.upperBound)
                let linkText = String(text[range])
                logger.debug("Obtained url text", metadata: ["size": "\(linkText.count)"])

                spans.append([
                    "start": byteStart,
                    "end": byteEnd,
                    "link": linkText
                ])
            }
        } catch {
            logger.error("Error while parsing urls", metadata: ["error": "\(error.localizedDescription)"])
        }

        logger.debug("URLs received", metadata: ["size": "\(spans.count)"])
        logger.trace("Exiting parseURLs()")
        return spans
    }

    /// Parses hashtags from a given text and returns them along with their positions.
    /// - Parameter text: The text to parse for hashtags.
    /// - Returns: An array of `Dictionary`s containing the start and end positions of each
    /// hashtag and the hashtag text.
    public static func parseHashtags(from text: String) -> [[String: Any]] {
        logger.trace("In parseHashtags()")
        var spans = [[String: Any]]()

        // Regex for grabbing #hashtags.
        let hashtagRegex = "(?<!\\w)(#[a-zA-Z0-9_]+)"

        do {
            logger.trace("Building regex")
            let regex = try NSRegularExpression(pattern: hashtagRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            // Get the start and end positions of each match.
            logger.trace("Enumerating matches")
            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match,
                      let range = Range(match.range(at: 1), in: text) else { return }
                logger.trace("Hashtag has been found")
                let byteStart = text.distance(from: text.startIndex, to: range.lowerBound)
                let byteEnd = text.distance(from: text.startIndex, to: range.upperBound)
                let hashtagText = String(text[range])
                logger.debug("Obtained hashtag text", metadata: ["size": "\(hashtagText.count)"])

                spans.append([
                    "start": byteStart,
                    "end": byteEnd,
                    "tag": hashtagText
                ])
            }
        } catch {
            logger.error("Error while parsing hashtags", metadata: ["error": "\(error.localizedDescription)"])
        }
        logger.trace("Exiting parseHashtags()")
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
        logger.trace("In parseFacets()")
        let facets = FacetsActor()

        await withTaskGroup(of: Void.self) { group in
            logger.trace("Parsing mentions")
            for mention in self.parseMentions(from: text) {
                group.addTask {
                    do {
                        // Unless something is wrong with `parseMentions()`, this is unlikely to fail.
                        guard let handle = mention["mention"] as? String else { return }
                        logger.debug("Mention text received", metadata: ["handle": "\(handle)"])

                        // Remove the `@` from the handle.
                        let notATHandle = String(handle.dropFirst())

//                        if let did = try await self.retrieveDID(from: notATHandle, pdsURL: pdsURL),
//                           let start = mention["start"] as? Int,
//                           let end = mention["end"] as? Int {
//
//                            let mentionFacet = Facet(
//                                index: ByteSlice(byteStart: start, byteEnd: end),
//                                features: [.mention(Mention(did: did))]
//                            )
//
//                            await facets.append(mentionFacet)
//                        }

                        let mentionResult = try await ATProtoKit().resolveHandle(from: notATHandle, pdsURL: pdsURL)
                        logger.debug("Mention result", metadata: ["result": "\(mentionResult)"])

                        switch mentionResult {
                            case .success(let resolveHandleOutput):
                                guard let start = mention["start"] as? Int, let end = mention["end"] as? Int else { return }

                                let mentionFacet = AppBskyLexicon.RichText.Facet(
                                    index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
                                    features: [.mention(AppBskyLexicon.RichText.Facet.Mention(did: resolveHandleOutput.handleDID))])

                                await facets.append(mentionFacet)
                                logger.debug("New mention facet added")
                            case .failure(let error):
                                logger.error("Error while processing mentions", metadata: ["error": "\(error)"])
                        }
                    } catch {
                        logger.error("Error while processing mentions", metadata: ["error": "\(error)"])
                    }
                }
            }

            // Grab all of the URLs and add them to the facet.
            logger.trace("Parsing urls")
            for link in self.parseURLs(from: text) {
                group.addTask {
                    // Unless something is wrong with `parseURLs()`, this is unlikely to fail.
                    guard let url = link["link"] as? String else { return }
                    logger.debug("URL text received", metadata: ["url": "\(url)"])

                    if let start = link["start"] as? Int,
                       let end = link["end"] as? Int {
                        let linkFacet = AppBskyLexicon.RichText.Facet(
                            index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
                            features: [.link(AppBskyLexicon.RichText.Facet.Link(uri: url))]
                        )

                        await facets.append(linkFacet)
                        logger.debug("New url facet added")
                    }
                }
            }

            // Grab all of the hashtags and add them to the facet.
            logger.trace("Parsing hashtags")
            for hashtag in self.parseHashtags(from: text) {
                group.addTask {
                    // Unless something is wrong with `parseHashtags()`, this is unlikely to fail.
                    guard let tag = hashtag["tag"] as? String else { return }
                    logger.debug("New hashtag text recieved", metadata: ["hashtag": "\(tag)"])

                    if let start = hashtag["start"] as? Int,
                       let end = hashtag["end"] as? Int {
                        let hashTagFacet = AppBskyLexicon.RichText.Facet(
                            index: AppBskyLexicon.RichText.Facet.ByteSlice(byteStart: start, byteEnd: end),
                            features: [.tag(AppBskyLexicon.RichText.Facet.Tag(tag: tag))]
                        )

                        await facets.append(hashTagFacet)
                        logger.debug("New hashtag facet added")
                    }
                }
            }
        }

        logger.trace("Exiting parseFacets()")
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
