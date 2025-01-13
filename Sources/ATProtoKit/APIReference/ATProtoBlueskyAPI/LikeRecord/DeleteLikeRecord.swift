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
    ///
    /// - Note: This can be either the URI of the like record, or the full record object itself.
    ///
    /// - Parameter record: The like record that needs to be deleted.
    public func deleteLikeRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
