//
//  ToolsOzoneVerificationListVerifications.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-18.
//

import Foundation

extension ToolsOzoneLexicon.Verification {

    /// The main data model definition for displaying a list of verifications.
    ///
    /// - Note: According to the AT Protocol specifications: "List verifications."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.listVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/listVerifications.json
    public struct ListVerifications: Sendable, Codable {

        /// The direction the list will be ordered.
        public enum SortDirection: String, Sendable, Codable {

            /// Ascending order.
            case ascending = "asc"

            /// Descending order.
            case descending = "desc"
        }
    }

    /// An output model for displaying a list of verifications.
    ///
    /// - Note: According to the AT Protocol specifications: "List verifications."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.listVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/listVerifications.json
    public struct ListVerificationsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of verifications.
        public let verifications: [ToolsOzoneLexicon.Verification.VerificationViewDefinition]
    }
}
