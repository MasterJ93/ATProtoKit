//
//  ComAtprotoModerationCreateReport.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Moderation {

    /// A request body model for creating a report.
    ///
    /// - Note: According to the AT Protocol specifications: "Submit a moderation report regarding
    /// an atproto account or record. Implemented by moderation services (with PDS proxying), and
    /// requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.moderation.createReport`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/createReport.json
    public struct CreateReportRequestBody: Sendable, Codable {

        /// The reason for the report.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates the broad category of
        /// violation the report is for."
        public let reasonType: ComAtprotoLexicon.Moderation.ReasonTypeDefinition

        /// Any clarifying comments accompanying the report. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Additional context about the
        /// content and violation."
        public let reason: String?

        /// The subject reference.
        ///
        /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
        ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
        ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
        ///   \
        ///   Clarifications from Bluesky are needed in order to fully understand this item.
        public let subject: SubjectUnion

        /// Moderation tool information for tracing the source of the action
        ///
        public let moderationTool: ModerationTool?
        
        public init(reasonType: ComAtprotoLexicon.Moderation.ReasonTypeDefinition, reason: String? = nil, subject: SubjectUnion, moderationTool: ModerationTool? = nil) {
            self.reasonType = reasonType
            self.reason = reason
            self.subject = subject
            self.moderationTool = moderationTool
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.reasonType = try container.decode(ComAtprotoLexicon.Moderation.ReasonTypeDefinition.self, forKey: .reasonType)
            self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
            self.subject = try container.decode(ComAtprotoLexicon.Moderation.CreateReportRequestBody.SubjectUnion.self, forKey: .subject)
            self.moderationTool = try container.decodeIfPresent(ModerationTool.self, forKey: .moderationTool)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.reasonType, forKey: .reasonType)
            try container.truncatedEncodeIfPresent(self.reason, forKey: .reason, upToCharacterLength: 20000)
            try container.encode(self.subject, forKey: .subject)
            try container.encodeIfPresent(self.moderationTool, forKey: .moderationTool)
        }
        
        public enum CodingKeys: String, CodingKey {
            case reasonType
            case reason
            case subject
            case moderationTool = "modTool"
        }
        
        // Unions
        /// The subject reference.
        public enum SubjectUnion: ATUnionProtocol {

            /// A repository reference.
            case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

            /// A strong reference.
            case strongReference(ComAtprotoLexicon.Repository.StrongReference)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "com.atproto.admin.defs#repoRef":
                        self = .repositoryReference(try ComAtprotoLexicon.Admin.RepositoryReferenceDefinition(from: decoder))
                    case "com.atproto.repo.strongRef":
                        self = .strongReference(try ComAtprotoLexicon.Repository.StrongReference(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .repositoryReference(let repositoryReference):
                        try container.encode(repositoryReference)
                    case .strongReference(let strongReference):
                        try container.encode(strongReference)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
        
        public struct ModerationTool: Sendable, Codable {
            
            public let name: String
            
            public let meta: UnknownType?
            
            public init(name: String, meta: UnknownType? = nil) {
                self.name = name
                self.meta = meta
            }
            
            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.name = try container.decode(String.self, forKey: .name)
                self.meta = try container.decodeIfPresent(UnknownType.self, forKey: .meta)
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.name, forKey: .name)
                try container.encodeIfPresent(self.meta, forKey: .meta)
            }
            
            public enum CodingKeys: CodingKey {
                case name
                case meta
            }
        }
    }

    /// An output model for creating a report.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.moderation.createReport`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/createReport.json
    public struct CreateReportOutput: Sendable, Codable {

        /// The ID of the report.
        public let id: Int

        /// The reason for the report.
        public let reasonType: ComAtprotoLexicon.Moderation.ReasonTypeDefinition

        /// The reason for the report. Optional.
        ///
        /// - Important: Current maximum length is 2,000 characters.
        public let reason: String?

        /// The offending subject in question.
        public let subject: SubjectUnion

        /// The decentralized identifier (DID) of the user who created the report.
        public let reportedBy: String

        /// The date and time the report was created.
        public let createdAt: Date

        public init(id: Int, reasonType: ComAtprotoLexicon.Moderation.ReasonTypeDefinition, reason: String?, subject: SubjectUnion,
                    reportedBy: String, createdAt: Date) {
            self.id = id
            self.reasonType = reasonType
            self.reason = reason
            self.subject = subject
            self.reportedBy = reportedBy
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int.self, forKey: .id)
            self.reasonType = try container.decode(ComAtprotoLexicon.Moderation.ReasonTypeDefinition.self, forKey: .reasonType)
            self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
            self.subject = try container.decode(SubjectUnion.self, forKey: .subject)
            self.reportedBy = try container.decode(String.self, forKey: .reportedBy)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.id, forKey: .id)
            try container.encode(self.reasonType, forKey: .reasonType)
            try container.truncatedEncodeIfPresent(self.reason, forKey: .reason, upToCharacterLength: 2_000)
            try container.encode(self.subject, forKey: .subject)
            try container.encode(self.reportedBy, forKey: .reportedBy)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        public enum CodingKeys: CodingKey {
            case id
            case reasonType
            case reason
            case subject
            case reportedBy
            case createdAt
        }

        // Unions
        /// The subject reference.
        public enum SubjectUnion: ATUnionProtocol {

            /// A repository reference.
            case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

            /// A strong reference.
            case strongReference(ComAtprotoLexicon.Repository.StrongReference)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "com.atproto.admin.defs#repoRef":
                        self = .repositoryReference(try ComAtprotoLexicon.Admin.RepositoryReferenceDefinition(from: decoder))
                    case "com.atproto.repo.strongRef":
                        self = .strongReference(try ComAtprotoLexicon.Repository.StrongReference(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .repositoryReference(let repositoryReference):
                        try container.encode(repositoryReference)
                    case .strongReference(let strongReference):
                        try container.encode(strongReference)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
}
