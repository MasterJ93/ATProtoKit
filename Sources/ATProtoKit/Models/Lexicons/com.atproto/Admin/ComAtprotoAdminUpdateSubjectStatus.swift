//
//  ComAtprotoAdminUpdateSubjectStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Admin {

    /// A request body model for updating a subject status of an account, record, or blob.
    ///
    /// - Note: According to the AT Protocol specifications: "Update the service-specific
    /// admin status of a subject (account, record, or blob)."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateSubjectStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateSubjectStatus.json
    public struct UpdateSubjectStatusRequestBody: Sendable, Codable {

        /// The subject associated with the subject status.
        public let subject: SubjectUnion

        /// The attributes of the user account's takedown. Optional.
        public let takedown: ComAtprotoLexicon.Admin.StatusAttributesDefinition?

        /// The attributes of the user account's deactivation. Optional.
        public let deactivated: ComAtprotoLexicon.Admin.StatusAttributesDefinition?

        // Unions
        /// The subject associated with the subject status.
        public enum SubjectUnion: ATUnionProtocol {

            /// A repository reference.
            case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

            /// A strong reference.
            case strongReference(ComAtprotoLexicon.Repository.StrongReference)

            /// A repository blob reference.
            case repositoryBlobReference(ComAtprotoLexicon.Admin.RepositoryBlobReferenceDefinition)

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
                    case "com.atproto.admin.defs#repoBlobRef":
                        self = .repositoryBlobReference(try ComAtprotoLexicon.Admin.RepositoryBlobReferenceDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }

            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                switch self {
                    case .repositoryReference(let value):
                        try container.encode("com.atproto.admin.defs#repoRef", forKey: .type)
                        try value.encode(to: encoder)
                    case .strongReference(let value):
                        try container.encode("com.atproto.repo.strongRef", forKey: .type)
                        try value.encode(to: encoder)
                    case .repositoryBlobReference(let value):
                        try container.encode("com.atproto.admin.defs#repoBlobRef", forKey: .type)
                        try value.encode(to: encoder)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }

    /// An output model for updating a subject status of an account, record, or blob.
    ///
    /// - Note: According to the AT Protocol specifications: "Update the service-specific admin
    /// status of a subject (account, record, or blob)."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateSubjectStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateSubjectStatus.json
    public struct UpdateSubjectStatusOutput: Sendable, Codable {

        /// The subject associated with the subject status.
        public let subject: SubjectUnion

        /// The status attributes of the subject. Optional.
        public let takedown: ComAtprotoLexicon.Admin.StatusAttributesDefinition?

        // Unions
        /// The subject associated with the subject status.
        public enum SubjectUnion: ATUnionProtocol {

            /// A repository reference.
            case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

            /// A strong reference.
            case strongReference(ComAtprotoLexicon.Repository.StrongReference)

            /// A repository blob reference.
            case repositoryBlobReference(ComAtprotoLexicon.Admin.RepositoryBlobReferenceDefinition)

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
                    case "com.atproto.admin.defs#repoBlobRef":
                        self = .repositoryBlobReference(try ComAtprotoLexicon.Admin.RepositoryBlobReferenceDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }

            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                switch self {
                    case .repositoryReference(let value):
                        try container.encode("com.atproto.admin.defs#repoRef", forKey: .type)
                        try value.encode(to: encoder)
                    case .strongReference(let value):
                        try container.encode("com.atproto.repo.strongRef", forKey: .type)
                        try value.encode(to: encoder)
                    case .repositoryBlobReference(let value):
                        try container.encode("com.atproto.admin.defs#repoBlobRef", forKey: .type)
                        try value.encode(to: encoder)
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
