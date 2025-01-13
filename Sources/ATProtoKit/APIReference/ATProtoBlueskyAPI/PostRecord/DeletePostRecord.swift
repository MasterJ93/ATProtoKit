//
//  DeletePostRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a post record.
    ///
    /// This can also be used to validate if a post record has been deleted.
    ///
    /// - Note: This can be either the URI of the post record, or the full record object itself.
    ///
    /// - Parameter record: The post record that needs to be deleted.
    public func deletePostRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
