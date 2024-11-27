//
//  DeleteRepostRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a repost record.
    ///
    /// This can also be used to validate if a repost record has been deleted.
    /// - Parameter record: The record that needs to be deleted.
    ///
    /// This can be either the URI of the record, or the full record object itself.
    public func deleteRepostRecord(_ record: RecordIdentifier) async throws {
        // in testing, I have found that I can use the preexisting deleteLikeRecord function to delete a repost without any issues.
        try await deleteLikeRecord(record)
    }
}
