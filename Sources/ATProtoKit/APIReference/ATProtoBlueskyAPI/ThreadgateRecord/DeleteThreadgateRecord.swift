//
//  DeleteThreadgateRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a threadgate record.
    ///
    /// This can also be used to validate if a threadgate record has been deleted.
    ///
    /// - Note: This can be either the URI of the threadgate record, or the full record
    /// object itself.
    ///
    /// - Parameter record: The threadgate record that needs to be deleted.
    public func deleteThreadgateRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
