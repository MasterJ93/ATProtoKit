//
//  CreateListItemRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to create a list item record to the user account in Bluesky.
    /// 
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// You need to have a list record first before you create a postgate record. If there isn't
    /// one yet, you can create one manually, or you can use the
    /// ``ATProtoBluesky/createListRecord(named:ofType:description:listAvatarImage:labels:creationDate:recordKey:shouldValidate:swapCommit:)``
    /// method.
    ///
    /// After that, you can use the ``ComAtprotoLexicon/Repository/StrongReference/recordURI``
    /// property as the value for the `listURI` argument.
    ///
    /// ```swift
    /// do {
    ///     let listResult = try await atProtoBluesky.createListRecord(
    ///         named: "Book Authors",
    ///         ofType: .reference
    ///     )
    ///
    ///     let listItemResult = try await atProtoBluesky.createListItemRecord(
    ///         for: listResult.recordURI,
    ///         subjectDID: "did:plc:bv6ggog3tya2z3vxsub7hnal"
    ///     )
    ///
    ///     print(listItemResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Note: If you make a duplicate entry, the AppView will simply ignore it.
    ///
    /// - Parameters:
    ///   - listURI: The URI of the list item.
    ///   - subjectDID: The decentralized identifier of the subject.
    ///   - recordKey: The record key of the collection. Optional. Defaults to `nil`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func createListItemRecord(
        for listURI: String,
        subjectDID: String,
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        do {
            _ = try await atProtoKitInstance.resolveDID(subjectDID)

            let uri = try ATProtoTools().parseURI(listURI)
            guard try await atProtoKitInstance.getRepositoryRecord(
                from: uri.repository,
                collection: uri.collection,
                recordKey: uri.recordKey
            ).value != nil else {
                throw ATProtoBlueskyError.recordNotFound(message: "List record (\(listURI)) not found.")
            }

            let listItemRecord = AppBskyLexicon.Graph.ListItemRecord(
                subjectDID: subjectDID,
                list: listURI,
                createdAt: Date()
            )

            return try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.graph.listItem",
                recordKey: recordKey ?? nil,
                shouldValidate: shouldValidate,
                record: UnknownType.record(listItemRecord),
                swapCommit: swapCommit ?? nil
            )
        } catch {
            throw error
        }
    }
}
