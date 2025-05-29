//
//  DeleteRecord.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-29.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a Bluesky record.
    ///
    /// This can also be used to validate if a record has been deleted.
    ///
    /// - Note: This can be either the URI of the record, or the full record object itself.
    ///
    /// - Parameter record: The block record that needs to be deleted.
    public func deleteRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
