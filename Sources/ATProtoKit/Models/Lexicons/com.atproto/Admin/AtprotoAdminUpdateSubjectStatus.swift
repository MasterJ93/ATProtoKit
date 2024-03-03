//
//  AtprotoAdminUpdateSubjectStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-03.
//

import Foundation

/// The main data model definition for updating a subject status of an account, record, or blob.
///
/// - Note: According to the AT Protocol specifications: "Update the service-specific admin status of a subject (account, record, or blob)."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.updateSubjectStatus`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateSubjectStatus.json
public struct AdminUpdateSubjectStatus: Codable {
    /// The subject associated with the subject status.
    public let subject: AdminGetSubjectStatusUnion
    /// The status attributes of the subject. Optional.
    public let takedown: AdminStatusAttributes?
}

/// A data model definition for the output of updating a subject status of an account, record, or blob.
///
/// - Note: According to the AT Protocol specifications: "Update the service-specific admin status of a subject (account, record, or blob)."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.updateSubjectStatus`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateSubjectStatus.json
public struct AdminUpdateSubjectStatusOutput: Codable {
    /// The subject associated with the subject status.
    public let subject: AdminGetSubjectStatusUnion
    /// The status attributes of the subject. Optional.
    public let takedown: AdminStatusAttributes?
}
