//
//  DeleteListRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a list record.
    ///
    /// This can also be used to validate if a list record has been deleted.
    ///
    /// - Note: This can be either the URI of the list record, or the full record object itself.
    ///
    /// - Parameter record: The list record that needs to be deleted.
    public func deleteListRecord(_ record: RecordIdentifier) async throws {
        return try await deleteLikeRecord(record)
    }
}
