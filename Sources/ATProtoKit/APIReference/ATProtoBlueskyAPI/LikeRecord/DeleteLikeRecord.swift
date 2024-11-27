//
//  DeleteLikeRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a like record.
    ///
    /// This can also be used to validate if a like record has been deleted.
    /// - Parameter record: The record that needs to be deleted.
    ///
    /// This can be either the URI of the record, or the full record object itself.
    public func deleteLikeRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
