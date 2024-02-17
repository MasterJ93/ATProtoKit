//
//  ATFacetParser.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

/// A utility class designed for parsing various elements like mentions, URLs, and hashtags from text.
public class ATFacetParser {
    /// Manages a collection of ``Facet`` objects, providing thread-safe append operations.
    actor FacetsActor {
        /// The collection of ``Facet`` objects.
        var facets = [Facet]()
        
        /// Appends a new ``Facet`` to the collection in a thread-safe manner.
        /// - Parameter facet: Parameter facet: The ``Facet`` to append.
        func append(_ facet: Facet) {
            facets.append(facet)
        }
    }

    /// Parses mentions from a given text and returns them along with their positions.
    /// - Parameter text: The text to parse for mentions.
    /// - Returns: An array of `Dictionary`s containing the start and end positions of each mention and the mention text.
    public static func parseMentions(from text: String) -> [[String: Any]] {
        var spans = [[String: Any]]()

        // Regex for grabbing @mentions.
        // Based on Bluesky's regex.
        let mentionRegex = "[\\s|^](@([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)"

        do {
            let regex = try NSRegularExpression(pattern: mentionRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            // Get the start and end positions of each match.
            regex.enumerateMatches(in: text, options: [], range: nsRange) { match, _, _ in
                guard let match = match,
                      let range = Range(match.range(at: 1), in: text) else { return }

                // Text must be in a UTF-8 encoded bytestring offset.
                let utf8Text = text.utf8
                let byteStart = utf8Text.distance(from: utf8Text.startIndex, to: utf8Text.index(utf8Text.startIndex, offsetBy: text.distance(from: text.startIndex, to: range.lowerBound)))
                let byteEnd = utf8Text.distance(from: utf8Text.startIndex, to: utf8Text.index(utf8Text.startIndex, offsetBy: text.distance(from: text.startIndex, to: range.upperBound)))
                let mentionText = String(text[range])

                spans.append([
                    "start": byteStart,
                    "end": byteEnd,
                    "mention": mentionText
                ])
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return spans
    }

    /// Parses URLs from a given text and returns them along with their positions.
    /// - Parameter text: The text to parse for URLs.
    /// - Returns: An array of `Dictionary`s containing the start and end positions of each URL and the URL text.
    public static func parseURLs(from text: String) -> [[String: Any]] {
        var spans = [[String: Any]]()

        // Regex for grabbing links.
        // Don't know if it can get every possible link.
        // Based on the regex Bluesky grabbed.
        let linkRegex = "[\\s|^](https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*[-a-zA-Z0-9@%_\\+~#//=])?)"

        do {
            let regex = try NSRegularExpression(pattern: linkRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            // Get the start and end positions of each match.
            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match,
                      let range = Range(match.range(at: 1), in: text) else { return }
                let byteStart = text.distance(from: text.startIndex, to: range.lowerBound)
                let byteEnd = text.distance(from: text.startIndex, to: range.upperBound)
                let linkText = String(text[range])

                spans.append([
                    "start": byteStart,
                    "end": byteEnd,
                    "link": linkText
                ])
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return spans
    }

    /// Parses hashtags from a given text and returns them along with their positions.
    /// - Parameter text: The text to parse for hashtags.
    /// - Returns: An array of `Dictionary`s containing the start and end positions of each hashtag and the hashtag text.
    public static func parseHashtags(from text: String) -> [[String: Any]] {
        var spans = [[String: Any]]()

        // Regex for grabbing #hashtags.
        let hashtagRegex = "(?<!\\w)(#[a-zA-Z0-9_]+)"

        do {
            let regex = try NSRegularExpression(pattern: hashtagRegex)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)

            // Get the start and end positions of each match.
            regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
                guard let match = match,
                      let range = Range(match.range(at: 1), in: text) else { return }
                let byteStart = text.distance(from: text.startIndex, to: range.lowerBound)
                let byteEnd = text.distance(from: text.startIndex, to: range.upperBound)
                let hashtagText = String(text[range])

                spans.append([
                    "start": byteStart,
                    "end": byteEnd,
                    "tag": hashtagText
                ])
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }
        return spans
    }

    /// Processes text to find mentions, URLs, and hashtags, converting these elements into ``Facet`` objects.
    /// - Parameters:
    ///   - text: The text to be processed.
    ///   - pdsURL: The URL of the Personal Data Server, defaulting to "https://bsky.social".
    /// - Returns: An array of ``Facet`` objects representing the structured data elements found in the text.
    public static func parseFacets(from text: String, pdsURL: String = "https://bsky.social") async -> [Facet] {
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

                        let mentionResult = try await ATProtoKit.retrieveDID(from: notATHandle, pdsURL: pdsURL)

                        switch mentionResult {
                            case .success(let resolveHandleOutput):
                                guard let start = mention["start"] as? Int, let end = mention["end"] as? Int else { return }

                                let mentionFacet = Facet(
                                    index: ByteSlice(byteStart: start, byteEnd: end),
                                    features: [.mention(Mention(did: resolveHandleOutput.handleDID))])

                                await facets.append(mentionFacet)
                            case .failure(let error):
                                print("Error: \(error)")
                        }
                    } catch {

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
                        let linkFacet = Facet(
                            index: ByteSlice(byteStart: start, byteEnd: end),
                            features: [.link(Link(uri: url))]
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
                    print("Hashtag: \(tag)")

                    if let start = hashtag["start"] as? Int,
                       let end = hashtag["end"] as? Int {
                        let hashTagFacet = Facet(
                            index: ByteSlice(byteStart: start, byteEnd: end),
                            features: [.tag(Tag(tag: tag))]
                        )

                        await facets.append(hashTagFacet)
                    }
                }
            }
        }

        return await facets.facets
    }
}
