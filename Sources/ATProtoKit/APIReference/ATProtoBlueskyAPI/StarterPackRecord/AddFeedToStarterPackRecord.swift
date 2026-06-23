//
//  AddFeedToStarterPackRecord.swift
//
//
//  Created by Christopher Jr Riley on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBluesky {

    /// A convenience method to add a feed to an existing starter pack record in Bluesky.
    ///
    /// This reads the current starter pack record, appends the feed, and updates the record.
    /// A starter pack can reference at most three feeds; adding a feed beyond that limit, or one
    /// that is already present, throws an ``ATProtoBlueskyError``.
    ///
    /// ```swift
    /// do {
    ///     let starterPackResult = try await atProtoBluesky.addFeedToStarterPackRecord(
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
    ///   - feedURI: The URI of the feed to add.
    /// - Returns: A strong reference, which contains the updated record's URI and CID hash.
    ///
    /// - Throws: An ``ATProtoBlueskyError`` if the record could not be found, the feed is already
    /// present, or the starter pack already references three feeds.
    public func addFeedToStarterPackRecord(
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

        var feeds = starterPack.feeds?.map { $0.uri } ?? []

        if feeds.contains(feedURI) {
            throw ATProtoBlueskyError.tooManyFeeds(message: "The feed (\(feedURI)) is already in the starter pack.")
        }

        if feeds.count >= 3 {
            throw ATProtoBlueskyError.tooManyFeeds(message: "A starter pack can contain at most three feeds.")
        }

        feeds.append(feedURI)

        return try await updateStarterPackRecord(
            starterPackURI: starterPackURI,
            feeds: feeds
        )
    }
}
