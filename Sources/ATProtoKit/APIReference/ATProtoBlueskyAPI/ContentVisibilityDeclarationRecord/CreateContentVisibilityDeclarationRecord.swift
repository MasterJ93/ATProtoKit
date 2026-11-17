//
//  CreateContentVisibilityDeclarationRecord.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBluesky {

    /// A convenience method to create a content visibility declaration record to the user account
    /// in Bluesky.
    ///
    /// This is used for declaring whether the user account requests that its posts be hidden from
    /// algorithmic recommendations.
    ///
    /// - Parameters:
    ///   - isHiddenFromAlgorithmicRecommendations: Indicates whether the user account requests
    ///   that its posts be hidden from algorithmic recommendations.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func createContentVisibilityDeclarationRecord(
        isHiddenFromAlgorithmicRecommendations: Bool,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let contentVisibilityDeclarationRecord = AppBskyLexicon.Actor.ContentVisibilityDeclarationRecord(
            isHiddenFromAlgorithmicRecommendations: isHiddenFromAlgorithmicRecommendations
        )

        do {
            let record = try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.actor.contentVisibilityDeclaration",
                recordKey: "self",
                shouldValidate: shouldValidate,
                record: UnknownType.record(contentVisibilityDeclarationRecord),
                swapCommit: swapCommit ?? nil
            )

            try await Task.sleep(nanoseconds: 500_000_000)

            return record
        } catch {
            throw error
        }
    }
}
