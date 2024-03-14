//
//  AtprotoAdminDeleteCommunicationTemplate.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-28.
//

import Foundation

/// The main data model definition for deleting a communication template as an administrator.
///
/// - Note: According to the AT Protocol specifications: "Delete a communication template."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.deleteCommunicationTemplate`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/deleteCommunicationTemplate.json
public struct AdminDeleteCommunicationTemplate: Codable {
    /// The ID of the communication template.
    public let id: String
}
