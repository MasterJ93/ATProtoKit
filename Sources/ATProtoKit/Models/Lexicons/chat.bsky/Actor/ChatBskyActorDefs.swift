//
//  ChatBskyActorDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension ChatBskyLexicon.Actor {

    /// A definition model for a basic profile view.
    ///
    /// - SeeAlso: This is based on the [`chat.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/actor/defs.json
    public struct ProfileViewBasicDefinition: Codable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The unique handle of the user.
        public let actorHandle: String

        /// The display name of the user account. Optional.
        ///
        /// - Important: Current maximum length is 64 characters.
        public let displayName: String?

        /// The avatar image URL of the user's profile. Optional.
        public let avatarImageURL: URL?

        /// The associated profile view. Optional.
        public let associated: AppBskyLexicon.Actor.ProfileAssociatedDefinition?

        /// The list of metadata relating to the requesting account's relationship with the
        /// subject account. Optional.
        public let viewer: [AppBskyLexicon.Actor.ViewerStateDefinition]?

        /// An array of labels created by the user. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// Indicates whether the user account can no longer be a part of the conversations. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Set to true when the actor
        /// cannot actively participate in converations"
        public let isChatDisabled: Bool?

        public init(actorDID: String, actorHandle: String, displayName: String?, avatarImageURL: URL?,
                    associated: AppBskyLexicon.Actor.ProfileAssociatedDefinition?, viewer: [AppBskyLexicon.Actor.ViewerStateDefinition]?,
                    labels: [ComAtprotoLexicon.Label.LabelDefinition]?, isChatDisabled: Bool?) {
            self.actorDID = actorDID
            self.actorHandle = actorHandle
            self.displayName = displayName
            self.avatarImageURL = avatarImageURL
            self.associated = associated
            self.viewer = viewer
            self.labels = labels
            self.isChatDisabled = isChatDisabled
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.actorDID = try container.decode(String.self, forKey: .actorDID)
            self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
            self.associated = try container.decodeIfPresent(AppBskyLexicon.Actor.ProfileAssociatedDefinition.self, forKey: .associated)
            self.viewer = try container.decodeIfPresent([AppBskyLexicon.Actor.ViewerStateDefinition].self, forKey: .viewer)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.isChatDisabled = try container.decodeIfPresent(Bool.self, forKey: .isChatDisabled)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.actorDID, forKey: .actorDID)
            try container.encode(self.actorHandle, forKey: .actorHandle)
            // Truncate `displayName` to 640 characters before encoding
            // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit implictly
            try truncatedEncodeIfPresent(self.displayName, withContainer: &container, forKey: .displayName, upToLength: 640)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
            try container.encodeIfPresent(self.associated, forKey: .associated)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.isChatDisabled, forKey: .isChatDisabled)
        }

        enum CodingKeys: String, CodingKey {
            case actorDID = "did"
            case actorHandle = "handle"
            case displayName
            case avatarImageURL = "avatar"
            case associated
            case viewer
            case labels
            case isChatDisabled = "chatDisabled"
        }
    }
}
