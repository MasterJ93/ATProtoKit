//
//  ToolsOzoneVerificationDefs.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-17.
//

import Foundation

extension ToolsOzoneLexicon.Verification {

    /// A definition model for a subject's verification data.
    ///
    /// - Note: According to the AT Protocol specifications: "Verification data for the associated subject."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.verification.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/verification/defs.json
    public struct VerificationDefinition: Sendable, Codable {

        /// The decentralized identifier (DID) of the user account that issued the verification.
        public let issuerDID: String

        /// The URI of the verification.
        public let uri: String

        /// The decentralized identifier (DID) of the user account being verified.
        public let subjectDID: String

        /// The handle of the verified user account.
        public let handle: String

        /// The display name of the verified user account.
        public let displayName: String

        /// The date and time the verification was created.
        public let createdAt: Date

        /// The reason the verification was revoked. Optional.
        public let revokeReason: String?

        /// The date and time the verification was revoked. Optional.
        public let revokedAt: Date?

        /// The decentralized identifier (DID) of the user account that revoked the verification. Optional.
        public let revokedByDID: String?

        /// The user account's profile. Optional.
        public let subjectProfile: SubjectProfileUnion?

        /// The issuer's profile. Optional.
        public let issuerProfile: IssueProfileUnion?

        /// The user account's repository. Optional.
        public let subjectRepository: SubjectRepositoryUnion?

        /// The issuer's repository. Optional.
        public let issuerRepository: IssuerRepositoryUnion?

        public init(
            issuerDID: String,
            uri: String,
            subjectDID: String,
            handle: String,
            displayName: String,
            createdAt: Date,
            revokeReason: String?,
            revokedAt: Date?,
            revokedByDID: String?,
            subjectProfile: SubjectProfileUnion?,
            issuerProfile: IssueProfileUnion?,
            subjectRepository: SubjectRepositoryUnion?,
            issuerRepository: IssuerRepositoryUnion?
        ) {
            self.issuerDID = issuerDID
            self.uri = uri
            self.subjectDID = subjectDID
            self.handle = handle
            self.displayName = displayName
            self.createdAt = createdAt
            self.revokeReason = revokeReason
            self.revokedAt = revokedAt
            self.revokedByDID = revokedByDID
            self.subjectProfile = subjectProfile
            self.issuerProfile = issuerProfile
            self.subjectRepository = subjectRepository
            self.issuerRepository = issuerRepository
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.issuerDID = try container.decode(String.self, forKey: .issuerDID)
            self.uri = try container.decode(String.self, forKey: .uri)
            self.subjectDID = try container.decode(String.self, forKey: .subjectDID)
            self.handle = try container.decode(String.self, forKey: .handle)
            self.displayName = try container.decode(String.self, forKey: .displayName)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
            self.revokeReason = try container.decodeIfPresent(String.self, forKey: .revokeReason)
            self.revokedAt = try container.decodeDateIfPresent(forKey: .revokedAt)
            self.revokedByDID = try container.decodeIfPresent(String.self, forKey: .revokedByDID)
            self.subjectProfile = try container.decodeIfPresent(SubjectProfileUnion.self, forKey: .subjectProfile)
            self.issuerProfile = try container.decodeIfPresent(IssueProfileUnion.self, forKey: .issuerProfile)
            self.subjectRepository = try container.decodeIfPresent(SubjectRepositoryUnion.self, forKey: .subjectRepository)
            self.issuerRepository = try container.decodeIfPresent(IssuerRepositoryUnion.self, forKey: .issuerRepository)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.issuerDID, forKey: .issuerDID)
            try container.encode(self.uri, forKey: .uri)
            try container.encode(self.subjectDID, forKey: .subjectDID)
            try container.encode(self.handle, forKey: .handle)
            try container.encode(self.displayName, forKey: .displayName)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.revokeReason, forKey: .revokeReason)
            try container.encodeDateIfPresent(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.revokedByDID, forKey: .revokedByDID)
            try container.encodeIfPresent(self.subjectProfile, forKey: .subjectProfile)
            try container.encodeIfPresent(self.issuerProfile, forKey: .issuerProfile)
            try container.encodeIfPresent(self.subjectRepository, forKey: .subjectRepository)
            try container.encodeIfPresent(self.issuerRepository, forKey: .issuerRepository)
        }

        enum CodingKeys: String, CodingKey {
            case issuerDID = "issuer"
            case uri
            case subjectDID = "subject"
            case handle
            case displayName
            case createdAt
            case revokeReason
            case revokedAt
            case revokedByDID = "revokedBy"
            case subjectProfile
            case issuerProfile
            case subjectRepository = "subjectRepo"
            case issuerRepository = "issuerRepo"
        }

        // Unions
        /// A reference containing the list of subject profiles.
        public struct SubjectProfileUnion: Sendable, Codable {}

        /// A reference containing the list of issuer profiles.
        public struct IssueProfileUnion: Sendable, Codable {}

        /// A reference containing the list of subject repositories..
        public enum SubjectRepositoryUnion: Sendable, Codable {

            /// A detailed repository view.
            case repositoryViewDetail(ToolsOzoneLexicon.Moderation.RepositoryViewDefinition)

            /// A respository view that couldn't be found.
            case repositoryViewNotFound(ToolsOzoneLexicon.Moderation.RepositoryViewNotFoundDefinition)

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(ToolsOzoneLexicon.Moderation.RepositoryViewDefinition.self) {
                    self = .repositoryViewDetail(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.RepositoryViewNotFoundDefinition.self) {
                    self = .repositoryViewNotFound(value)
                } else {
                    throw DecodingError.typeMismatch(
                        SubjectRepositoryUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown SubjectRepositoryUnion type"))
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .repositoryViewDetail(let value):
                        try container.encode(value)
                    case .repositoryViewNotFound(let value):
                        try container.encode(value)
                }
            }
        }

        /// A reference containing the list of issuer repositories.
        public enum IssuerRepositoryUnion: Sendable, Codable {

            /// A detailed repository view.
            case repositoryViewDetail(ToolsOzoneLexicon.Moderation.RepositoryViewDefinition)

            /// A respository view that couldn't be found.
            case repositoryViewNotFound(ToolsOzoneLexicon.Moderation.RepositoryViewNotFoundDefinition)

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(ToolsOzoneLexicon.Moderation.RepositoryViewDefinition.self) {
                    self = .repositoryViewDetail(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.RepositoryViewNotFoundDefinition.self) {
                    self = .repositoryViewNotFound(value)
                } else {
                    throw DecodingError.typeMismatch(
                        SubjectRepositoryUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown SubjectRepositoryUnion type"))
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .repositoryViewDetail(let value):
                        try container.encode(value)
                    case .repositoryViewNotFound(let value):
                        try container.encode(value)
                }
            }
        }
    }
}
