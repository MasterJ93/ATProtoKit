//
//  GetOriginalPostFromQuote.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-27.
//

import Foundation

extension ATProtoBluesky {

    /// Extracts the original Bluesky post from the quote post.
    ///
    /// Since quote posts are simply posts that have a record embedded inside them, this method is a
    /// short-handed way of:
    /// - Getting a post,
    /// - Using a `switch` statement to go to the record embed, and
    /// - Viewing the record embed view.
    ///
    /// You need to use a method that allows you to use a ``AppBskyLexicon/Feed/PostViewDefinition`` model.
    ///
    /// ```swift
    /// let atProtoKit = await ATProtoKit(sessionConfiguration: config)
    /// let atProtoBluesky = ATProtoBluesky(atProtoKitInstance: atProtoKit)
    ///
    /// let post = try await atProtoKit.getAuthorFeed(by: "lucy.bsky.social").feed[0].post
    /// let originalPost = try atProtoBluesky.getOriginalPost(from: post)
    ///
    /// guard let originalPost = originalPost else { return }
    /// print(originalPost)
    /// ```
    ///
    /// - Parameter quotePostView: The quoted post, as a post record.
    /// - Returns: An embedded record view.
    ///
    /// - Throws: An error if the record was deleted, blocked, or otherwise not found or viewable.
    public func getOriginalPost(from quotePostView: AppBskyLexicon.Feed.PostViewDefinition) throws -> AppBskyLexicon.Feed.PostRecord? {
        let embed = quotePostView.embed

        switch embed {
            case .embedRecordView(let recordView):
                let record = try self.getEmbeddedRecord(recordView.record)
                return record
            case .embedRecordWithMediaView(let recordWithMediaView):
                let record = try self.getEmbbeddedRecordFromRecordAndMediaEmbed(recordWithMediaView)
                return record
            default:
                throw GetOriginalPostsFromQuotePostsError.recordNotFound
        }
    }

    /// Extracts the embedded record from the union enum.
    ///
    /// - Parameter embeddedRecordViewContainer: The record view container.
    /// - Returns: A view of the record.
    ///
    /// - Throws: An error if the record was deleted, blocked, or otherwise not found or viewable.
    private func getEmbeddedRecord(_ embeddedRecordViewContainer: ATUnion.RecordViewUnion) throws -> AppBskyLexicon.Feed.PostRecord? {
        switch embeddedRecordViewContainer {
            case .viewRecord(let viewRecord):
                let recordValue = viewRecord.value
                let record = recordValue.getRecord(ofType: AppBskyLexicon.Feed.PostRecord.self)
                return record
            case .viewNotFound(_):
                throw GetOriginalPostsFromQuotePostsError.recordNotFound
            case .viewBlocked(_):
                throw GetOriginalPostsFromQuotePostsError.recordBlocked
            case .viewDetached(_):
                throw GetOriginalPostsFromQuotePostsError.recordDetacted
            default:
                throw GetOriginalPostsFromQuotePostsError.recordNotFound
        }
    }

    /// Extracts the embedded record from the union enum.
    ///
    /// - Parameter recordAndMediaEmbed:
    private func getEmbbeddedRecordFromRecordAndMediaEmbed(_ recordAndMediaEmbed: AppBskyLexicon.Embed.RecordWithMediaDefinition.View) throws -> AppBskyLexicon.Feed.PostRecord? {
        let record = recordAndMediaEmbed.record.record
        switch record {
            case .viewRecord(let viewRecord):
                let recordValue = viewRecord.value
                let record = recordValue.getRecord(ofType: AppBskyLexicon.Feed.PostRecord.self)
                return record
            default:
                throw GetOriginalPostsFromQuotePostsError.recordNotFound
        }
    }
}
