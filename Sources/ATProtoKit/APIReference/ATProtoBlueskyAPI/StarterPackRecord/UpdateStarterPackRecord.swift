//
//  UpdateStarterPackRecord.swift
//
//
//  Created by Christopher Jr Riley on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBluesky {

    /// A convenience method to update a starter pack record in the user account in Bluesky.
    ///
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// The current record is fetched first, and any argument left as `nil` keeps the existing
    /// value, so you only need to supply the fields you want to change.
    ///
    /// ```swift
    /// do {
    ///     let starterPackResult = try await atProtoBluesky.updateStarterPackRecord(
    ///         starterPackURI: "at://did:plc:example/app.bsky.graph.starterpack/3kabcde",
    ///         name: "Updated Name"
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
    ///   - starterPackURI: The URI of the starter pack.
    ///   - name: The new name of the starter pack. Optional. Defaults to `nil` (unchanged).
    ///   - description: The new description of the starter pack. Optional. Defaults to `nil`
    ///   (unchanged).
    ///   - descriptionFacets: The new facets within the description. Optional. Defaults to `nil`
    ///   (unchanged).
    ///   - listURI: The new URI of the reference list. Optional. Defaults to `nil` (unchanged).
    ///   - feeds: The new array of feed URIs. Optional. Defaults to `nil` (unchanged).
    /// - Returns: A strong reference, which contains the updated record's URI and CID hash.
    ///
    /// - Throws: An ``ATProtoBlueskyError`` if the record could not be found or more than three
    /// feeds are provided, or an error related to the AT Protocol if the record could not be
    /// updated.
    public func updateStarterPackRecord(
        starterPackURI: String,
        name: String? = nil,
        description: String? = nil,
        descriptionFacets: [AppBskyLexicon.RichText.Facet]? = nil,
        listURI: String? = nil,
        feeds: [String]? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        if let feeds = feeds, feeds.count > 3 {
            throw ATProtoBlueskyError.tooManyFeeds(message: "A starter pack can contain at most three feeds.")
        }

        let uri = try ATProtoTools().parseURI(starterPackURI)

        guard let record = try await atProtoKitInstance.getRepositoryRecord(
            from: uri.repository,
            collection: uri.collection,
            recordKey: uri.recordKey
        ).value,
              let starterPack = record.getRecord(ofType: AppBskyLexicon.Graph.StarterpackRecord.self) else {
            throw ATProtoBlueskyError.recordNotFound(message: "Starter pack record (\(starterPackURI)) not found.")
        }

        // Carry over the current values, overriding only the fields that were supplied.
        let newName = name.map { $0.truncated(toLength: 50) } ?? starterPack.name

        let newDescription: String?
        let newDescriptionFacets: [AppBskyLexicon.RichText.Facet]?

        if let description = description {
            let truncatedDescription = description.truncated(toLength: 300)
            newDescription = truncatedDescription

            if let descriptionFacets = descriptionFacets {
                newDescriptionFacets = descriptionFacets
            } else {
                newDescriptionFacets = await ATFacetParser.parseFacets(from: truncatedDescription, pdsURL: session.pdsURL ?? "https://bsky.social")
            }
        } else {
            newDescription = starterPack.description
            newDescriptionFacets = descriptionFacets ?? starterPack.descriptionFacets
        }

        let newListURI = listURI ?? starterPack.listURI

        let newFeeds: [AppBskyLexicon.Graph.StarterpackRecord.FeedItem]
        if let feeds = feeds {
            newFeeds = feeds.map { AppBskyLexicon.Graph.StarterpackRecord.FeedItem(uri: $0) }
        } else {
            newFeeds = starterPack.feeds ?? []
        }

        let starterPackRecord = AppBskyLexicon.Graph.StarterpackRecord(
            name: newName,
            description: newDescription,
            descriptionFacets: newDescriptionFacets,
            listURI: newListURI,
            feeds: newFeeds,
            createdAt: starterPack.createdAt
        )

        do {
            return try await atProtoKitInstance.putRecord(
                repository: session.sessionDID,
                collection: "app.bsky.graph.starterpack",
                recordKey: uri.recordKey,
                record: UnknownType.record(starterPackRecord)
            )
        } catch {
            throw error
        }
    }
}
