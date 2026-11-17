//
//  UpdateContentVisibilityDeclarationRecord.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBluesky {

    /// A convenience method to update a content visibility declaration record to the user account
    /// in Bluesky.
    ///
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// - Parameters:
    ///   - isHiddenFromAlgorithmicRecommendations: Indicates whether the user account requests
    ///   that its posts be hidden from algorithmic recommendations.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func updateContentVisibilityDeclarationRecord(
        isHiddenFromAlgorithmicRecommendations: Bool
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let contentVisibilityDeclarationRecord = AppBskyLexicon.Actor.ContentVisibilityDeclarationRecord(
            isHiddenFromAlgorithmicRecommendations: isHiddenFromAlgorithmicRecommendations
        )

        do {
            guard try await atProtoKitInstance.getRepositoryRecord(
                from: session.sessionDID,
                collection: "app.bsky.actor.contentVisibilityDeclaration",
                recordKey: "self"
            ).value != nil else {
                throw ATProtoBlueskyError.recordNotFound(message: "Content visibility declaration record not found.")
            }

            return try await atProtoKitInstance.putRecord(
                repository: session.sessionDID,
                collection: "app.bsky.actor.contentVisibilityDeclaration",
                recordKey: "self",
                record: UnknownType.record(contentVisibilityDeclarationRecord)
            )
        } catch {
            throw error
        }
    }
}
