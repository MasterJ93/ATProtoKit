//
//  BskyUnspeccedDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

/// A data model definition for a skeleton search post.
///
/// - Important: This is an unspecced model, and as such, this is highly volatile and may change or be removed at any time. Use at your
/// own risk.
/// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
public struct UnspeccedSkeletonSearchPost: Codable {
    /// The URI of the skeleton search post.
    public let postURI: String

    enum CodingKeys: String, CodingKey {
        case postURI = "uri"
    }
}

/// A data model definition for a skeleton search post.
///
/// - Important: This is an unspecced model, and as such, this is highly volatile and may change or be removed at any time. Use at your
/// own risk.
/// - SeeAlso: This is based on the [`app.bsky.unspecced.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/defs.json
public struct UnspeccedSkeletonSearchActor: Codable {
    /// The URI of the skeleton search actor.
    public let actorDID: String

    enum CodingKeys: String, CodingKey {
        case actorDID = "did"
    }
}
