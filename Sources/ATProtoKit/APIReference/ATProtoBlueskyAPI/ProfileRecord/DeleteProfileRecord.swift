//
//  DeleteProfileRecord.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-28.
//

import Foundation

extension ATProtoBluesky {

    /// Deletes a profile record.
    ///
    /// This can also be used to validate if a profile record has been deleted.
    ///
    /// - Note: This can be either the URI of the profile record, or the full record object itself.
    ///
    /// - Parameter record: The profile record that needs to be deleted.
    public func deleteProfileRecord(_ record: RecordIdentifier) async throws {
        return try await deleteActionRecord(record)
    }
}
