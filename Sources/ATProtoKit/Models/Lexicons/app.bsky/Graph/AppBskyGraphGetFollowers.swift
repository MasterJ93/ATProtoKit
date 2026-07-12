//
//  AppBskyGraphGetFollowers.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Graph {

    /// An output model for getting all of the user account's followers.
    ///
    /// - Note: According to the AT Protocol specifications: "Enumerates accounts which follow a
    /// specified account (actor)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.getFollowers`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/getFollowers.json
    public struct GetFollowersOutput: Sendable, Codable {

        /// The user account itself.
        public let subject: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of user accounts that follow the user account.
        public let followers: [AppBskyLexicon.Actor.ProfileViewDefinition]
        
        public init(subject: AppBskyLexicon.Actor.ProfileViewDefinition, cursor: String?, followers: [AppBskyLexicon.Actor.ProfileViewDefinition]) {
            self.subject = subject
            self.cursor = cursor
            self.followers = followers
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.subject = try container.decode(AppBskyLexicon.Actor.ProfileViewDefinition.self, forKey: .subject)
            self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor)
            self.followers = try container.decode([AppBskyLexicon.Actor.ProfileViewDefinition].self, forKey: .followers)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.subject, forKey: .subject)
            try container.encodeIfPresent(self.cursor, forKey: .cursor)
            try container.encode(self.followers, forKey: .followers)
        }
        
        enum CodingKeys: CodingKey {
            case subject
            case cursor
            case followers
        }
    }
}
