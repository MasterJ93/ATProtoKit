//
//  BskyUnspeccedSearchActorsSkeleton.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

/// The main data model definition for the output of retrieving the skeleton results of actors (users).
///
/// - Important: This is an unspecced model, and as such, this is highly volatile and may change
/// or be removed at any time. Use at your own risk.
///
/// - Note: According to the AT Protocol specifications: "Backend Actors (profile) search, returns
/// only skeleton."
///
/// - SeeAlso: This is based on the [`app.bsky.unspecced.searchActorsSkeleton`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/searchActorsSkeleton.json
public struct UnspeccedSearchActorsSkeletonOutput: Codable {
    /// The mark used to indicate the starting point for the next set of result. Optional.
    public let cursor: String?
    /// The number of search results.
    ///
    /// This number may not be completely reliable, as it can be rounded or truncated. This number
    /// doesn't reflect all of the possible actors that can be seen.
    ///
    /// - Note: According to the AT Protocol specifications: "Count of search hits. Optional, may
    /// be rounded/truncated, and may not be possible to paginate through all hits."
    public let hitsTotal: Int?
    /// An array of actors.
    public let actors: [UnspeccedSkeletonSearchActor]
}
