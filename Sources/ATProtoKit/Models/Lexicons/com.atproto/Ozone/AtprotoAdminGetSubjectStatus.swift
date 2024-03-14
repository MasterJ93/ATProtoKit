//
//  AtprotoAdminGetSubjectStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

/// A data model definition for the output of getting the status of a subject as an administrator.
///
/// - Note: According to the AT Protocol specifications: "Get the service-specific admin status of a subject (account, record, or blob)."
///
/// - SeeAlso: This is based on the [`com.atproto.admin.getSubjectStatus`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/getSubjectStatus.json
public struct AdminGetSubjectStatusOutput: Codable {
    public let subject: AdminGetSubjectStatusUnion
    public let takedown: AdminStatusAttributes
}

/// A reference containing the list of repository references.
public enum AdminGetSubjectStatusUnion: Codable {
    /// A repository reference.
    case repositoryReference(AdminRepositoryReference)
    /// A strong reference.
    case strongReference(StrongReference)
    /// A repository blob reference.
    case repoBlobReference(AdminRepoBlobReference)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(AdminRepositoryReference.self) {
            self = .repositoryReference(value)
        } else if let value = try? container.decode(StrongReference.self) {
            self = .strongReference(value)
        } else if let value = try? container.decode(AdminRepoBlobReference.self) {
            self = .repoBlobReference(value)
        } else {
            throw DecodingError.typeMismatch(AdminEventViewUnion.self,
                                             DecodingError.Context(codingPath: decoder.codingPath,
                                                                   debugDescription: "Unknown AdminGetSubjectStatusUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
            case .repositoryReference(let repositoryReference):
                try container.encode(repositoryReference)
            case .strongReference(let strongReference):
                try container.encode(strongReference)
            case .repoBlobReference(let repoBlobReference):
                try container.encode(repoBlobReference)
        }
    }
}
