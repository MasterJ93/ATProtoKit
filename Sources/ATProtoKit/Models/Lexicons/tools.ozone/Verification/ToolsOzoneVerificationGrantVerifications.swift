//
//  ToolsOzoneVerificationGrantVerifications.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-17.
//

import Foundation

extension ToolsOzoneLexicon.Verification {

    /// The main data model definition for giving out a verification to user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Grant verifications to multiple subjects.
    /// Allows batch processing of up to 100 verifications at once."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.grantVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/grantVerifications.json
    public struct GrantVerifications: Sendable, Codable {

        /// A verification request.
        public struct VerificationInput: Sendable, Codable {

            /// The decentralized identifier (DID) of the user account being verified.
            ///
            /// - Note: According to the AT Protocol specifications: "The did of the subject being verified"
            public let subjectDID: String

            /// The handle of the user account being verified.
            ///
            /// - Note: According to the AT Protocol specifications: "Handle of the subject the
            /// verification applies to at the moment of verifying."
            public let handle: String

            /// The display name of the user account being verified.
            ///
            /// - Note: According to the AT Protocol specifications: "Display name of the subject the
            /// verification applies to at the moment of verifying."
            public let displayName: String

            /// The date and time the verification request had been created. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Timestamp for verification record.
            /// Defaults to current time when not specified."
            public let createdAt: Date?

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.subjectDID = try container.decode(String.self, forKey: .subjectDID)
                self.handle = try container.decode(String.self, forKey: .handle)
                self.displayName = try container.decode(String.self, forKey: .displayName)
                self.createdAt = try container.decodeDateIfPresent(forKey: .createdAt)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.subjectDID, forKey: .subjectDID)
                try container.encode(self.handle, forKey: .handle)
                try container.encode(self.displayName, forKey: .displayName)
                try container.encodeDateIfPresent(self.createdAt, forKey: .createdAt)
            }

            enum CodingKeys: String, CodingKey {
                case subjectDID = "subject"
                case handle
                case displayName
                case createdAt
            }
        }

        /// A verification failure.
        ///
        /// - Note: According to the AT Protocol specifications: "Error object for failed verifications."
        public struct GrantError: Sendable, Codable {

            /// The error of the verification failure.
            ///
            /// - Note: According to the AT Protocol specifications: "Error message describing the reason
            /// for failure."
            public let error: String

            /// The decentralized identifier (DID) of the user account who's verification was unsuccessful.
            ///
            /// - Note: According to the AT Protocol specifications: "The did of the subject being verified"
            public let subject: String
        }
    }

    /// A request body model for giving out a verification to user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Grant verifications to multiple subjects.
    /// Allows batch processing of up to 100 verifications at once."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.grantVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/grantVerifications.json
    public struct GrantVerificationsRequestBody: Sendable, Codable {

        /// An array of verification requests.
        ///
        /// - Note: According to the AT Protocol specifications: "Array of verification requests to process."
        public let verifications: [GrantVerifications.VerificationInput]

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.verifications, forKey: .verifications)
            try container.truncatedEncode(self.verifications, forKey: .verifications, upToArrayLength: 100)
        }
    }

    /// An output model for giving out a verification to user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Grant verifications to multiple subjects.
    /// Allows batch processing of up to 100 verifications at once."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.grantVerifications`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/grantVerifications.json
    public struct GrantVerificationsOutput: Sendable, Codable {

        /// An array of successful verifications.
        public let verifications: [ToolsOzoneLexicon.Verification.VerificationViewDefinition]

        /// An array of unsuccessful verifications.
        public let failedVerifications: [GrantVerifications.GrantError]
    }
}
