//
//  CreateStarterPackRecord.swift
//
//
//  Created by Christopher Jr Riley on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBluesky {

    /// A convenience method to create a starter pack record to the user account in Bluesky.
    ///
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// A starter pack groups a reference list of user accounts together with up to three feeds,
    /// giving new users a curated starting point. The `listURI` must point to an existing
    /// reference list record (created via ``createListRecord(named:ofType:description:listAvatarImage:labels:creationDate:recordKey:shouldValidate:swapCommit:)``
    /// with a type of ``ListType/reference``).
    ///
    /// ```swift
    /// do {
    ///     let starterPackResult = try await atProtoBluesky.createStarterPackRecord(
    ///         named: "Book Authors",
    ///         listURI: "at://did:plc:example/app.bsky.graph.list/3kabcde",
    ///         feeds: ["at://did:plc:example/app.bsky.feed.generator/whats-hot"]
    ///     )
    ///
    ///     print(starterPackResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Note: Names can be up to 50 characters long. \
    /// \
    /// Descriptions can be up to 300 characters long. \
    /// \
    /// A starter pack can reference up to three feeds.
    ///
    /// - Parameters:
    ///   - name: The name of the starter pack.
    ///   - description: The starter pack's description. Optional. Defaults to `nil`.
    ///   - listURI: The URI of the reference list the starter pack is built around.
    ///   - feeds: An array of feed URIs to include in the starter pack. Optional.
    ///   Defaults to an empty array.
    ///   - creationDate: The date of the starter pack record. Defaults to `Date.now`.
    ///   - recordKey: The record key of the collection. Optional. Defaults to `nil`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    ///
    /// - Throws: An ``ATProtoBlueskyError`` if more than three feeds are provided, or an error
    /// related to the AT Protocol if the record could not be created.
    public func createStarterPackRecord(
        named name: String,
        description: String? = nil,
        listURI: String,
        feeds: [String] = [],
        creationDate: Date = Date(),
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        // feeds
        // A starter pack can reference at most three feeds.
        if feeds.count > 3 {
            throw ATProtoBlueskyError.tooManyFeeds(message: "A starter pack can contain at most three feeds.")
        }

        // name
        // Truncate the number of characters to 50.
        let nameText = name.truncated(toLength: 50)

        // description and descriptionFacets
        var descriptionText: String? = nil
        var descriptionFacets: [AppBskyLexicon.RichText.Facet]? = nil

        if let description = description {
            // Truncate the number of characters to 300.
            let truncatedDescriptionText = description.truncated(toLength: 300)
            descriptionText = truncatedDescriptionText

            let facets = await ATFacetParser.parseFacets(from: truncatedDescriptionText, pdsURL: session.pdsURL ?? "https://bsky.social")
            descriptionFacets = facets
        }

        let feedItems = feeds.map { AppBskyLexicon.Graph.StarterpackRecord.FeedItem(uri: $0) }

        let starterPackRecord = AppBskyLexicon.Graph.StarterpackRecord(
            name: nameText,
            description: descriptionText,
            descriptionFacets: descriptionFacets,
            listURI: listURI,
            feeds: feedItems,
            createdAt: creationDate
        )

        do {
            let record = try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.graph.starterpack",
                recordKey: recordKey ?? nil,
                shouldValidate: shouldValidate,
                record: UnknownType.record(starterPackRecord),
                swapCommit: swapCommit ?? nil
            )

            try await Task.sleep(nanoseconds: 500_000_000)

            return record
        } catch {
            throw error
        }
    }
}
