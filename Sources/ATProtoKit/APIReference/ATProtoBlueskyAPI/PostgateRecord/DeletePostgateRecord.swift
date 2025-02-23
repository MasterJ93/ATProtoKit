//
//  DeletePostgateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-13.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a postgate record.
    ///
    /// This can also be used to validate if a postgate record has been deleted.
    ///
    /// - Note: This can be either the URI of the postgate record, or the full record
    /// object itself.
    ///
    /// - Parameter record: The postgate record that needs to be deleted.
    public func deletePostgateRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
