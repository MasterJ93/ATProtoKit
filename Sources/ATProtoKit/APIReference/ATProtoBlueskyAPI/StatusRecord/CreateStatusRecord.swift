//
//  CreateStatusRecord.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-04.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBluesky {

    /// A convenience method to create a status record to the user account in Bluesky.
    ///
    /// This is used for showing the status of a user account, such as whether the user is live.
    ///
    /// - Parameters:
    ///   - status: The status of the user account.
    ///   - embed: The embedded content related to the status. Optional.
    ///   - durationMinutes: The amount of time the status has lasted in minutes. Optional.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional. Defaults to `true`.
    /// - Returns: A
    /// ``ComAtprotoLexicon/Repository/StrongReference``
    /// structure which represents the record that was successfully created.
    public func createStatusRecord(
        _ status: AppBskyLexicon.Actor.StatusRecord.Status,
        embed: AppBskyLexicon.Embed.ExternalDefinition? = nil,
        durationMinutes: Int? = nil,
        shouldValidate: Bool? = true
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        var resolvedEmbed: AppBskyLexicon.Actor.StatusRecord.EmbedUnion? = nil

        if let embed = embed {
            resolvedEmbed = .externalView(embed)
        }

        let statusRecord = AppBskyLexicon.Actor.StatusRecord(
            status: status,
            embed: resolvedEmbed,
            durationMinutes: durationMinutes,
            createdAt: Date()
        )

        do {
            let record = try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.actor.status",
                shouldValidate: shouldValidate,
                record: UnknownType.record(statusRecord)
            )

            try await Task.sleep(nanoseconds: 500_000_000)

            return record
        } catch {
            throw error
        }
    }
}
