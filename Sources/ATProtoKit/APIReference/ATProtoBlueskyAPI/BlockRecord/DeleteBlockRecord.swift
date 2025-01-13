//
//  DeleteBlockRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a block record.
    ///
    /// This can also be used to validate if a block record has been deleted.
    ///
    /// - Note: This can be either the URI of the block record, or the full record object itself.
    ///
    /// - Parameter record: The block record that needs to be deleted.
    public func deleteBlockRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
