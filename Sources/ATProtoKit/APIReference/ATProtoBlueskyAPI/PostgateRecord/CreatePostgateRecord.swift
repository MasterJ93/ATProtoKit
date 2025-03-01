//
//  CreatePostgateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-13.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to create a postgate record to the user account in Bluesky.
    /// 
    /// This can be used instead of creating your own method if you wish not to do so.
    /// 
    /// You need to have a record first before you create a postgate record. If there isn't one
    /// yet, you can create one manually, or you can use the
    /// ``ATProtoBluesky/createPostRecord(text:inlineFacets:locales:replyTo:embed:labels:tags:creationDate:recordKey:shouldValidate:swapCommit:)``
    /// method.
    /// 
    /// After that, you can use the ``ComAtprotoLexicon/Repository/StrongReference/recordURI``
    /// property as the value for the `postURI` argument.
    ///
    /// ```swift
    /// do {
    ///     let post = try await atProtoBluesky.createPostRecord(
    ///         text: "Spent 3 hours debugging only to realize I was working in the wrong file... 🙃"
    ///     )
    ///
    ///     let postgateResult = try await atProtoBluesky.createPostgateRecord(
    ///         postURI: post.recordURI
    ///     )
    ///
    ///     print(postgateResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// # Managing Embedding Post Options
    ///
    /// You can detact the post from quote posts by using the `detachedEmbeddingURIs` argument.
    /// When doing so, Bluesky will display a "Removed by author" warning and the quote post will
    /// not appear in the "Show Quotes" section.
    ///
    /// - Note: Bluesky currently has a limit of 50 posts for you to detach.
    ///
    /// You can also disable the ability to embed the post altogether by using the
    /// `embeddingRules` argument.
    ///
    /// ```swift
    /// do {
    ///     let post = try await atProtoBluesky.createPostRecord(
    ///         text: "My cat decided my lap was her office chair.\n\nGuess I’m legally required to sit here and do nothing now..."
    ///     )
    ///
    ///     let postgateResult = try await atProtoBluesky.createPostgateRecord(
    ///         postURI: post.recordURI,
    ///         embeddingRules: [.disable]
    ///     )
    ///
    ///     print(postgateResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - postURI: The URI of the post.
    ///   - detachedEmbeddingURIs: An array of URIs belonging to posts that the `postURI`'s author
    ///   has detached. Optional.
    ///   - embeddingRules: An array of rules for embedding the post. Optional.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func createPostgateRecord(
        postURI: String,
        detachedEmbeddingURIs: [String]? = nil,
        embeddingRules: [PostgateEmbeddingRule]? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session else {
            throw ATRequestPrepareError.missingActiveSession
        }

        // Check to see if the post exists.
        guard let post = try await atProtoKitInstance.getPosts([postURI]).posts.first else {
            throw ATProtoBlueskyError.postNotFound(message: "Post (\(postURI)) not found.")
        }

        var postgateEmbedRules: [ATUnion.EmbeddingRulesUnion] = []

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
            let recordKey = try ATProtoTools().parseURI(recordURI).recordKey

            return try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.feed.postgate",
                recordKey: recordKey,
                shouldValidate: shouldValidate,
                record: UnknownType.record(postgateRecord),
                swapCommit: swapCommit ?? nil
            )
        } catch {
            throw error
        }
    }

    /// A list of restrictions and rules for embedding a post.
    public enum PostgateEmbeddingRule {

        /// Embedding posts have been disabled entirely.
        case disable
    }
}
