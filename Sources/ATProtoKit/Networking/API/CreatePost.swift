//
//  CreatePost.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

extension ATProtoKit {
    public func createPost(text: String, locales: [Locale] = [], replyTo: String? = nil, embed: EmbedUnion? = nil, labels: FeedLabelUnion? = nil, tags: [String]? = nil) async -> Result<StrongReference, Error> {

        guard let pdsURL = session.pdsURL,
              let url = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.createRecord") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        // Replies
        var resolvedReplyTo: ReplyReference? = nil
        if let replyURI = replyTo {
            do {
                resolvedReplyTo = try await ATProtoKit.resolveReplyReferences(parentURI: replyURI)
            } catch {
                return .failure(error)
            }
        }
        // Locales
        let localeIdentifiers = locales.isEmpty ? nil : locales.map { $0.identifier }

        // Compiling all parts of the post into one.
        let post = FeedPost(
            text: text,
            facets: await ParseHelper.parseFacets(from: text, pdsURL: session.accessJwt),
            reply: resolvedReplyTo,
            embed: embed,
            languages: localeIdentifiers,
            labels: labels,
            tags: tags,
            createdAt: Date.now)

        let requestBody = FeedPostRequestBody(
            repo: session.did,
            record: post)

        let request = APIClientService.createRequest(forRequest: url, andMethod: .post, authorizationValue: "Bearer \(session.accessJwt)")

        do {
            let result = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: StrongReference.self)

            return .success(result)
        } catch {
            return .failure(error)
        }
    }

    struct FeedPostRequestBody: Encodable {
        let repo: String
        let collection: String = "app.bsky.feed.post"
        let record: FeedPost
    }
}
