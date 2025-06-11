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
    public struct GetSubjectStatusOutput: Sendable, Codable {

        /// The subject itself.
        public let subject: SubjectUnion

        /// The attributes of the takedown event. Optional.
        public let takedown: StatusAttributesDefinition?

        /// The attributes of the deactivation event. Optional.
        public let deactivated: StatusAttributesDefinition?

        // Unions
        /// The subject itself.
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
                let type = try container.decode(String.self, forKey: .type)

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

                        self = .unknown(type, dictionary)
                }

            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .repositoryReference(let value):
                        try container.encode(value)
                    case .strongReference(let value):
                        try container.encode(value)
                    case .repositoryBlobReference(let value):
                        try container.encode(value)
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
