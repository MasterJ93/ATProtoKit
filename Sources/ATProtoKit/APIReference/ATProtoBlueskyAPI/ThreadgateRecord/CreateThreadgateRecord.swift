//
//  CreateThreadgateRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to create a threadgate record to the user account in Bluesky.
    /// 
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// You need to have a record first before you create a threadgate record. If there isn't one
    /// yet, you can create one manually, or you can use the
    /// ``ATProtoBluesky/createPostRecord(text:inlineFacets:locales:replyTo:embed:labels:tags:creationDate:recordKey:shouldValidate:swapCommit:)``
    /// method.
    ///
    /// After that, you can use the ``ComAtprotoLexicon/Repository/StrongReference/recordURI``
    /// property as the value for the `postURI` argument.
    ///
    /// # Managing Allowlist Options
    ///
    /// With the `replyControls` argument, you can specifiy the specific retrictions you want
    /// for the post.
    ///
    /// ```swift
    /// do {
    ///     let post = try await atProtoBluesky.createPostRecord(
    ///         text: "My cat decided my lap was her office chair.\n\nGuess I’m legally required to sit here and do nothing now..."
    ///     )
    ///
    ///     let threadgateResult = try await atProtoBluesky.createThreadgateRecord(
    ///         postURI: post.recordURI,
    ///         replyControls: [.allowFollowers, .allowFollowing]
    ///     )
    ///
    ///     print(threadgateResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - postURI: The URI of the post.
    ///   - replyControls: An array of rules used as an allowlist. Optional.
    ///   - hiddenReplyURIs: An array of hidden replies in the form of URIs. Optional.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func createThreadgateRecord(
        postURI: String,
        replyControls: [ThreadgateAllowRule]? = nil,
        hiddenReplyURIs: [String]? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        // Check to see if the post exists.
        guard let post = try await atProtoKitInstance.getPosts([postURI]).posts.first else {
            throw ATProtoBlueskyError.recordNotFound(message: "Post record (\(postURI)) not found.")
        }

        var threadgateAllowArray: [AppBskyLexicon.Feed.ThreadgateRecord.ThreadgateUnion] = []

        if let replyControls = replyControls, replyControls.isEmpty == false {
            let cappedReplyControls = Array(replyControls.prefix(5))

            for replyControl in cappedReplyControls {
                switch replyControl {
                    case .allowMentions:
                        threadgateAllowArray.append(.mentionRule(AppBskyLexicon.Feed.ThreadgateRecord.MentionRule()))
                    case .allowFollowers:
                        threadgateAllowArray.append(.followerRule(AppBskyLexicon.Feed.ThreadgateRecord.FollowerRule()))
                    case .allowFollowing:
                        threadgateAllowArray.append(.followingRule(AppBskyLexicon.Feed.ThreadgateRecord.FollowingRule()))
                    case .allowList(listURI: let listURI):
                        threadgateAllowArray.append(.listRule(AppBskyLexicon.Feed.ThreadgateRecord.ListRule(listURI: listURI)))
                }
            }
        }

        let finalThreadgateAllowArray = threadgateAllowArray.isEmpty ? nil : threadgateAllowArray

        let threadgateRecord = AppBskyLexicon.Feed.ThreadgateRecord(
            postURI: postURI,
            allow: finalThreadgateAllowArray,
            createdAt: Date(),
            hiddenReplies: hiddenReplyURIs
        )

        do {
            let recordURI = post.uri
            let recordKey = try ATProtoTools().parseURI(recordURI).recordKey

            let record = try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.feed.threadgate",
                recordKey: recordKey,
                shouldValidate: shouldValidate,
                record: UnknownType.record(threadgateRecord),
                swapCommit: swapCommit ?? nil
            )

            try await Task.sleep(nanoseconds: 500_000_000)

            return record
        } catch {
            throw error
        }
    }

    /// A list of rules used as an allowlist.
    public enum ThreadgateAllowRule {

        /// A rule that allows users that were mentioned in the user account's post to reply to
        /// said post.
        case allowMentions

        /// A rule that allows users who follow you to reply to the user account's post.
        case allowFollowers

        /// A rule that allows users that are followed by the user account to reply to the post.
        case allowFollowing

        /// A rule that allows users are in a specified list to reply to the post.
        ///
        /// - Parameter list: The URI of the list.
        case allowList(listURI: String)
    }
}
