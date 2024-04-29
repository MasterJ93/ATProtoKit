//
//  BskyGraphGetSuggestedFollowsByActor.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

/// The main data model definition for the output of getting the list of user accounts that
/// requesting user account is suggested to follow.
///
/// - Note: According to the AT Protocol specifications: "Enumerates follows similar to a given
/// account (actor). Expected use is to recommend additional accounts immediately after following
/// one account."
///
/// - SeeAlso: This is based on the [`app.bsky.graph.getSuggestedFollowsByActor`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getSuggestedFollowsByActor.json
public struct GraphGetSuggestedFollowsByActorOutput: Codable {
    /// An array of user accounts the requesting user account is suggested to follow.
    public let suggestions: [ActorProfileView]
}
