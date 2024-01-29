//
//  CreatePost.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

extension ATProtoKit {
    public func createPost(text: String, locales: [Locale] = [], replyTo: ReplyReference? = nil, embed: EmbedUnion? = nil, labels: FeedLabelUnion? = nil, tags: [String]? = nil) async -> Result<StrongReference, Error> {

        guard let url = URL(string: "\(session.pdsURL)/xrpc/com.atproto.repo.createRecord") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"]))
        }

        // Locales
        let localeIdentifiers = locales.isEmpty ? nil : locales.map { $0.identifier }

        // Compiling all parts of the post into one.
        let post = FeedPost(
            text: text,
            facets: await ParseHelper.parseFacets(from: text, pdsURL: session.accessJwt),
            reply: replyTo,
            embed: embed,
            langs: localeIdentifiers,
            labels: labels,
            tags: tags,
            createdAt: Date())

        let requestBody: [String: Any] = [
            "repo": session.did,
            "collection": "app.bsky.feed.post",
            "record": post
        ]

        let request = APIClientService.createRequest(forRequest: url, andMethod: .post, authValue: "Bearer \(session.accessJwt)")

        do {
            let result = try await APIClientService.sendRequest(request, jsonData: requestBody, decodeTo: StrongReference.self)

            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
