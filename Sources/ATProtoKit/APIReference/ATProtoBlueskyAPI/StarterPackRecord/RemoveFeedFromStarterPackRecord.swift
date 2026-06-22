//
//  RemoveFeedFromStarterPackRecord.swift
//
//
//  Created by Christopher Jr Riley on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBluesky {

    /// A convenience method to remove a feed from an existing starter pack record in Bluesky.
    ///
    /// This reads the current starter pack record, removes the feed, and updates the record.
    /// If the feed is not present in the starter pack, an ``ATProtoBlueskyError`` is thrown.
    ///
    /// ```swift
    /// do {
    ///     let starterPackResult = try await atProtoBluesky.removeFeedFromStarterPackRecord(
    ///         starterPackURI: "at://did:plc:example/app.bsky.graph.starterpack/3kabcde",
    ///         feedURI: "at://did:plc:example/app.bsky.feed.generator/whats-hot"
    ///     )
    ///
    ///     print(starterPackResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - starterPackURI: The URI of the starter pack.
    ///   - feedURI: The URI of the feed to remove.
    /// - Returns: A strong reference, which contains the updated record's URI and CID hash.
    ///
    /// - Throws: An ``ATProtoBlueskyError`` if the record could not be found or the feed is not
    /// present in the starter pack.
    public func removeFeedFromStarterPackRecord(
        starterPackURI: String,
        feedURI: String
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        let uri = try ATProtoTools().parseURI(starterPackURI)

        guard let record = try await atProtoKitInstance.getRepositoryRecord(
            from: uri.repository,
            collection: uri.collection,
            recordKey: uri.recordKey
        ).value,
              let starterPack = record.getRecord(ofType: AppBskyLexicon.Graph.StarterpackRecord.self) else {
            throw ATProtoBlueskyError.recordNotFound(message: "Starter pack record (\(starterPackURI)) not found.")
        }

        let feeds = starterPack.feeds?.map { $0.uri } ?? []

        guard feeds.contains(feedURI) else {
            throw ATProtoBlueskyError.recordNotFound(message: "The feed (\(feedURI)) is not in the starter pack.")
        }

        let updatedFeeds = feeds.filter { $0 != feedURI }

        return try await updateStarterPackRecord(
            starterPackURI: starterPackURI,
            feeds: updatedFeeds
        )
    }
}
