//
//  DeleteListItemRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a list item record.
    ///
    /// This can also be used to validate if a list item record has been deleted.
    ///
    /// - Note: This can be either the URI of the list item record, or the full record
    /// object itself.
    ///
    /// - Parameter record: The list item record that needs to be deleted.
    public func deleteListItemRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
