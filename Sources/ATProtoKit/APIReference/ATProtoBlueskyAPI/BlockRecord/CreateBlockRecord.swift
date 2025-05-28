//
//  CreateBlockRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Creates a block record to block a specific user account.
    ///
    /// - Parameters:
    ///   - blockType: The type of block record to create.
    ///   - createdAt: The date and time the block record is created. Defaults to `Date()`.
    ///   - recordKey: The record key of the collection. Optional. Defaults to `nil`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A
    /// ``ComAtprotoLexicon/Repository/StrongReference``
    /// structure which represents the record that was successfully created.
    public func createBlockRecord(
        ofType blockType: BlockType,
        createdAt: Date = Date(),
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        var record: any ATRecordProtocol
        var collection: String

        switch blockType {
            case .actorBlock(actorDID: let actorDID):
                do {
                    record = AppBskyLexicon.Graph.BlockRecord(
                        subjectDID: actorDID,
                        createdAt: createdAt
                    )

                    collection = "app.bsky.graph.block"
                } catch {
                    throw error
                }
            case .listBlock(listURI: let listURI):
                do {
                    let uri = try ATProtoTools().parseURI(listURI)

                    guard try await atProtoKitInstance.getRepositoryRecord(
                        from: uri.repository,
                        collection: uri.collection,
                        recordKey: uri.recordKey
                    ).value?.getRecord(ofType: AppBskyLexicon.Graph.ListRecord.self)?.purpose == .modlist else {
                        throw ATProtoBlueskyError.recordNotFound(message: "Moderation list record (\(listURI)) not found.")
                    }

                    record = AppBskyLexicon.Graph.ListBlockRecord(
                        listURI: listURI,
                        createdAt: Date()
                    )
                    collection = "app.bsky.graph.listBlock"
                } catch {
                    throw error
                }
        }

        do {
            return try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: collection,
                recordKey: recordKey,
                shouldValidate: shouldValidate,
                record: UnknownType.record(record),
                swapCommit: swapCommit
            )
        } catch {
            throw error
        }
    }

    /// The type of block.
    public enum BlockType {

        /// Indicates the block record will be for blocking another user account.
        ///
        /// - Parameter actorDID: The decentralized identifier (DID) of the user account to block.
        case actorBlock(actorDID: String)

        /// Indicates the block record will be for blocking all user accounts within a list.
        ///
        /// - Parameter listURI: The URI of the list.
        case listBlock(listURI: String)
    }
}
