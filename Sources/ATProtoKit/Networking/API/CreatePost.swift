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

//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        request.addValue("Bearer \(session.accessJwt)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "repo": session.did,
            "collection": "app.bsky.feed.post",
            "record": post
        ]

        let request = APIClientService.createRequest(forRequest: url, andMethod: .post, authValue: "Bearer \(session.accessJwt)")

        do {
            let result = try await APIClientService.sendRequest(request, jsonData: requestBody, decodeTo: StrongReference.self)

//            guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
//                return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error encoding request body"]))
//            }
//
//            request.httpBody = httpBody
//
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw URLError(.badServerResponse)
//            }
//
//            if httpResponse.statusCode != 200 {
//                throw URLError(.badServerResponse)
//            }
//
//            let decoder = JSONDecoder()
//            let postResponse = try decoder.decode(StrongReference.self, from: data)
//
//            return .success(postResponse)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
