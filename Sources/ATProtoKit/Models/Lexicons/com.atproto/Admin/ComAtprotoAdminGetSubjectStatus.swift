//
//  ComAtprotoAdminGetSubjectStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Admin {

    /// An output model for getting the status of a subject as an administrator.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the service-specific admin status of
    /// a subject (account, record, or blob)."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.getSubjectStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getSubjectStatus.json
    public struct GetSubjectStatusOutput: Codable {

        /// The subject itself.
        public let subject: ATUnion.AdminGetSubjectStatusUnion

        /// The attributes of the takedown event. Optional.
        public let takedown: StatusAttributesDefinition?

        /// The attributes of the deactivation event. Optional.
        public let deactivated: StatusAttributesDefinition?
    }
}
