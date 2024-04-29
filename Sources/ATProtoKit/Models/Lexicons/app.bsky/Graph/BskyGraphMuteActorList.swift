//
//  BskyGraphMuteActorList.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation

/// The main data model definition for muting a list.
///
/// - Note: According to the AT Protocol specifications: "Creates a mute relationship for the
/// specified list of accounts. Mutes are private in Bluesky. Requires auth."
///
/// - SeeAlso: This is based on the [`app.bsky.graph.muteActorList`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/muteActor.json
public struct GraphMuteActorList: Codable {
    /// The URI of a list.
    public let listURI: String

    enum CodingKeys: String, CodingKey {
        case listURI = "list"
    }
}
