//
//  ToolsOzoneVerificationRevokeVerification.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-18.
//

import Foundation

extension ToolsOzoneLexicon.Verification {

    /// The main data model definition for revoking an array of verifications.
    ///
    /// - Note: According to the AT Protocol specifications: "Revoke previously granted verifications in
    /// batches of up to 100."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.revokeVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/revokeVerifications.json
    public struct RevokeVerifications: Sendable, Codable {

        /// An error related to revoking verifications.
        public struct RevokeError: Sendable, Codable {

            /// The verification record URI to revoke.
            ///
            /// - Note: According to the AT Protocol specifications: "The AT-URI of the verification record that failed
            /// to revoke."
            public let recordURI: String

            /// The error that descibes why the revocation has failed.
            ///
            /// - Note: According to the AT Protocol specifications: "Description of the error that occurred during revocation."
            public let error: String

            enum CodingKeys: String, CodingKey {
                case recordURI = "uri"
                case error
            }
        }
    }

    /// A request body model for revoking an array of verifications.
    ///
    /// - Note: According to the AT Protocol specifications: "Revoke previously granted verifications in
    /// batches of up to 100."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.revokeVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/revokeVerifications.json
    public struct RevokeVerificationsRequestBody: Sendable, Codable {

        /// An array of verification record URIs.
        ///
        /// - Note: According to the AT Protocol specifications: "Array of verification record uris to revoke."
        public let recordURIs: [String]

        /// The reason the verification is being revoked.
        ///
        /// - Note: According to the AT Protocol specifications: "Reason for revoking the verification. This is
        /// optional and can be omitted if not needed."
        public let revokeReason: String

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.truncatedEncode(self.recordURIs, forKey: .recordURIs, upToArrayLength: 100)
            try container.truncatedEncode(self.revokeReason, forKey: .revokeReason, upToCharacterLength: 100)
        }

        enum CodingKeys: String, CodingKey {
            case recordURIs = "uris"
            case revokeReason
        }
    }

    /// An output model for revoking an array of verifications.
    ///
    /// - Note: According to the AT Protocol specifications: "Revoke previously granted verifications in
    /// batches of up to 100."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.revokeVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/revokeVerifications.json
    public struct RevokeVerificationsOutput: Sendable, Codable {

        /// An array of verification record URIs that have been revoked.
        ///
        /// - Note: According to the AT Protocol specifications: "List of verification uris successfully revoked."
        public let revokedVerifications: [String]

        /// An array of verification errors.
        ///
        /// - Note: According to the AT Protocol specifications: "List of verification uris that couldn't be revoked, including
        /// failure reasons."
        public let failedRevocations: [ToolsOzoneLexicon.Verification.RevokeVerifications.RevokeError]
    }
}
