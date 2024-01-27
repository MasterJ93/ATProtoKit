//
//  ParseHelper.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

public class ParseHelper {

    public struct IdentityResponse: Codable {
        let did: String
    }

    actor FacetsActor {
        var facets = [Facet]()

        func append(_ facet: Facet) {
            facets.append(facet)
        }
    }

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

                        if let did = try await self.retrieveDID(from: notATHandle, pdsURL: pdsURL),
                           let start = mention["start"] as? Int,
                           let end = mention["end"] as? Int {

                            let mentionFacet = Facet(
                                index: ByteSlice(byteStart: start, byteEnd: end),
                                features: [.mention(Mention(did: did))]
                            )

                            await facets.append(mentionFacet)
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

    static func retrieveDID(from handle: String, pdsURL: String) async throws -> String? {
        // Go to AT Protocol to find the handle in order to see if it exists.
        guard let url = URL(string: "\(pdsURL)/xrpc/com.atproto.identity.resolveHandle") else {
            return nil
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "handle", value: handle)]

        guard let queryURL = components?.url else {
            return nil
        }

        print("Request URL: \(queryURL.absoluteString)")  // Debugging line

        var request = URLRequest(url: queryURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("Status Code: \(httpResponse.statusCode)")  // Debugging line
        print("Response Headers: \(httpResponse.allHeaderFields)")  // Debugging line

        if httpResponse.statusCode == 400 {
            print("Request failed. Error code 400.")
            return nil
        }

        let decodedResponse = try JSONDecoder().decode(ResolveHandleOutput.self, from: data)
        print("Decoded Response.did: \(decodedResponse.did)")
        return decodedResponse.did
    }
}
