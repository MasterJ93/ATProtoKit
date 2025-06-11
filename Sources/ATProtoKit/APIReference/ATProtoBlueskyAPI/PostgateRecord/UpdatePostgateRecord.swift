//
//  UpdatePostgateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-25.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to update a postgate record to the user account in Bluesky.
    /// 
    /// This can be used instead of creating your own method if you wish not to do so.
    /// 
    /// - Parameters:
    ///   - postURI: The URI of the post.
    ///   - detachedEmbeddingURIs: An array of URIs belonging to posts that the `postURI`'s author
    ///   has detached. Optional.
    ///   - embeddingRules: An array of rules for embedding the post. Optional.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func updatePostgateRecord(
        postURI: String,
        detachedEmbeddingURIs: [String]? = nil,
        embeddingRules: [PostgateEmbeddingRule]? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        // Check to see if the post exists.
        guard let post = try await atProtoKitInstance.getPosts([postURI]).posts.first else {
            throw ATProtoBlueskyError.recordNotFound(message: "Post record (\(postURI)) not found.")
        }

        var postgateEmbedRules: [AppBskyLexicon.Feed.PostgateRecord.EmbeddingRulesUnion] = []

        // Loop through any items in embedRules, if any.
        if let embeddingRules = embeddingRules, embeddingRules.isEmpty == false {
            for rule in embeddingRules {
                switch rule {
                    case .disable:
                        postgateEmbedRules.append(.disabledRule(AppBskyLexicon.Feed.PostgateRecord.DisableRule()))
                }
            }
        }

        let finalPostgateEmbedRules = postgateEmbedRules.isEmpty ? nil : postgateEmbedRules

        let postgateRecord = AppBskyLexicon.Feed.PostgateRecord(
            createdAt: post.record.getRecord(ofType: AppBskyLexicon.Feed.PostgateRecord.self)?.createdAt ?? Date(),
            postURI: postURI,
            detachedEmbeddingURIs: detachedEmbeddingURIs,
            embeddingRules: finalPostgateEmbedRules
        )

        do {
            let recordURI = post.uri
            let uri = try ATProtoTools().parseURI(recordURI)

            guard try await atProtoKitInstance.getRepositoryRecord(
                from: uri.repository,
                collection: uri.collection,
                recordKey: uri.recordKey
            ).value != nil else {
                throw ATProtoBlueskyError.recordNotFound(message: "Postgate record not found.")
            }

            return try await atProtoKitInstance.putRecord(
                repository: session.sessionDID,
                collection: "app.bsky.feed.postgate",
                recordKey: uri.recordKey,
                record: UnknownType.record(postgateRecord)
            )
        } catch {
            throw error
        }
    }
}
