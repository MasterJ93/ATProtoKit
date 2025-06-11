//
//  UpdateThreadgateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-25.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to update a threadgate record to the user account in Bluesky.
    ///
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// - Parameters:
    ///   - postURI: The URI of the post.
    ///   - replyControls: An array of rules used as an allowlist. Optional.
    ///   - hiddenReplyURIs: An array of hidden replies in the form of URIs. Optional.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func updateThreadgateRecord(
        postURI: String,
        replyControls: [ThreadgateAllowRule]? = nil,
        hiddenReplyURIs: [String]? = nil
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
            let uri = try ATProtoTools().parseURI(recordURI)

            guard try await atProtoKitInstance.getRepositoryRecord(
                from: uri.repository,
                collection: uri.collection,
                recordKey: uri.recordKey
            ).value != nil else {
                throw ATProtoBlueskyError.recordNotFound(message: "Threadgate record not found.")
            }

            return try await atProtoKitInstance.putRecord(
                repository: session.sessionDID,
                collection: "app.bsky.feed.threadgate",
                recordKey: uri.recordKey,
                record: UnknownType.record(threadgateRecord)
            )
        } catch {
            throw error
        }
    }
}
