//
//  DeleteFollowRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a follow record.
    ///
    /// This can also be used to validate if a follow record has been deleted.
    ///
    /// - Note: This can be either the URI of the follow record, or the full record object itself.
    ///
    /// - Parameter record: The follow record that needs to be deleted.
    public func deleteFollowRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
