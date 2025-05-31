//
//  AppBskyActorDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-16.
//

import Foundation

extension AppBskyLexicon.Actor {

    /// A definition model for a basic profile view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileViewBasicDefinition: Sendable, Codable, Equatable, Hashable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The unique handle of the user.
        public let actorHandle: String

        /// The display name of the user. Optional.
        ///
        /// - Important: Current maximum length is 64 characters.
        public let displayName: String?

        /// The avatar image URL of the user's profile. Optional.
        public let avatarImageURL: URL?

        /// The associated profile view. Optional.
        public let associated: ProfileAssociatedDefinition?

        /// The list of metadata relating to the requesting account's relationship with the
        /// subject account. Optional.
        public let viewer: ViewerStateDefinition?

        /// An array of labels created by the user. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The date and time the profile was created. Optional.
        public let createdAt: Date?

        /// The state of verification for the user account. Optional.
        public let verificationState: VerificationStateDefinition?

        /// The status of the user account. Optional.
        public let status: StatusViewDefinition?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.actorDID = try container.decode(String.self, forKey: .actorDID)
            self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
            self.associated = try container.decodeIfPresent(AppBskyLexicon.Actor.ProfileAssociatedDefinition.self, forKey: .associated)
            self.viewer = try container.decodeIfPresent(AppBskyLexicon.Actor.ViewerStateDefinition.self, forKey: .viewer)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.createdAt = try container.decodeDateIfPresent(forKey: .createdAt)
            self.verificationState = try container.decodeIfPresent(VerificationStateDefinition.self, forKey: .verificationState)
            self.status = try container.decodeIfPresent(StatusViewDefinition.self, forKey: .status)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.actorDID, forKey: .actorDID)
            try container.encode(self.actorHandle, forKey: .actorHandle)
            try container.truncatedEncodeIfPresent(self.displayName, forKey: .displayName, upToCharacterLength: 64)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
            try container.encodeIfPresent(self.associated, forKey: .associated)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeDateIfPresent(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.verificationState, forKey: .verificationState)
            try container.encodeIfPresent(self.status, forKey: .status)
        }

        enum CodingKeys: String, CodingKey {
            case actorDID = "did"
            case actorHandle = "handle"
            case displayName
            case avatarImageURL = "avatar"
            case associated
            case viewer
            case labels
            case createdAt
            case verificationState = "verification"
            case status
        }
    }

    /// A definition model for a profile view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileViewDefinition: Sendable, Codable, Equatable, Hashable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The unique handle of the user.
        public let actorHandle: String

        /// The display name of the user's profile. Optional.
        ///
        /// - Important: Current maximum length is 64 characters.
        public let displayName: String?

        /// The description of the user's profile. Optional.
        ///
        /// - Important: Current maximum length is 256 characters.
        public let description: String?

        /// The avatar image URL of a user's profile. Optional.
        public let avatarImageURL: URL?

        /// The associated profile view. Optional.
        public let associated: ProfileAssociatedDefinition?

        /// The date the profile was last indexed. Optional.
        public let indexedAt: Date?

        /// The date and time the profile was created. Optional.
        public let createdAt: Date?

        /// The list of metadata relating to the requesting account's relationship with the
        /// subject account. Optional.
        public let viewer: ViewerStateDefinition?

        /// An array of labels created by the user. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// The state of verification for the user account. Optional.
        public let verificationState: VerificationStateDefinition?

        /// The status of the user account. Optional.
        public let status: StatusViewDefinition?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.actorDID = try container.decode(String.self, forKey: .actorDID)
            self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
            self.associated = try container.decodeIfPresent(AppBskyLexicon.Actor.ProfileAssociatedDefinition.self, forKey: .associated)
            self.indexedAt = try container.decodeDateIfPresent(forKey: .indexedAt)
            self.createdAt = try container.decodeDateIfPresent(forKey: .createdAt)
            self.viewer = try container.decodeIfPresent(AppBskyLexicon.Actor.ViewerStateDefinition.self, forKey: .viewer)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.verificationState = try container.decodeIfPresent(VerificationStateDefinition.self, forKey: .verificationState)
            self.status = try container.decodeIfPresent(StatusViewDefinition.self, forKey: .status)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.actorDID, forKey: .actorDID)
            try container.encode(self.actorHandle, forKey: .actorHandle)
            try container.truncatedEncodeIfPresent(self.displayName, forKey: .displayName, upToCharacterLength: 64)
            try container.truncatedEncodeIfPresent(self.description, forKey: .description, upToCharacterLength: 256)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
            try container.encodeIfPresent(self.associated, forKey: .associated)
            try container.encodeDateIfPresent(self.indexedAt, forKey: .indexedAt)
            try container.encodeDateIfPresent(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.verificationState, forKey: .verificationState)
            try container.encodeIfPresent(self.status, forKey: .status)
        }
        
        enum CodingKeys: String, CodingKey {
            case actorDID = "did"
            case actorHandle = "handle"
            case displayName
            case description
            case avatarImageURL = "avatar"
            case associated
            case indexedAt
            case createdAt
            case viewer
            case labels
            case verificationState = "verification"
            case status
        }
    }

    /// A definition model for a detailed profile view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileViewDetailedDefinition: Sendable, Codable, Equatable, Hashable {

        /// The decentralized identifier (DID) of the user.
        public let actorDID: String

        /// The unique handle of the user.
        public let actorHandle: String

        /// The display name of the user's profile. Optional.
        ///
        /// - Important: Current maximum length is 64 characters.
        public let displayName: String?

        /// The description of the user's profile. Optional.
        ///
        /// - Important: Current maximum length is 256 characters.
        public let description: String?

        /// The avatar image URL of a user's profile. Optional.
        public let avatarImageURL: URL?

        /// The banner image URL of a user's profile. Optional.
        public let bannerImageURL: URL?

        /// The number of followers a user has. Optional.
        public let followerCount: Int?

        /// The number of accounts the user follows. Optional.
        public let followCount: Int?

        /// The number of posts the user has. Optional.
        public let postCount: Int?

        /// The associated profile view. Optional.
        public let associated: ProfileAssociatedDefinition?

        /// The starter pack the user account used to join Bluesky. Optional.
        public let joinedViaStarterPack: AppBskyLexicon.Graph.StarterPackViewBasicDefinition?

        /// The date the profile was last indexed. Optional.
        public let indexedAt: Date?

        /// The date and time the profile was created. Optional.
        public let createdAt: Date?

        /// The list of metadata relating to the requesting account's relationship with the
        /// subject account. Optional.
        public let viewer: ViewerStateDefinition?

        /// An array of labels created by the user. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        /// A post record that's pinned to the profile. Optional.
        public let pinnedPost: ComAtprotoLexicon.Repository.StrongReference?

        /// The state of verification for the user account. Optional.
        public let verificationState: VerificationStateDefinition?

        /// The status of the user account. Optional.
        public let status: StatusViewDefinition?

        public init(actorDID: String, actorHandle: String, displayName: String? = nil, description: String? = nil, avatarImageURL: URL? = nil,
                    bannerImageURL: URL? = nil, followerCount: Int? = nil, followCount: Int? = nil, postCount: Int? = nil,
                    associated: ProfileAssociatedDefinition?, joinedViaStarterPack: AppBskyLexicon.Graph.StarterPackViewBasicDefinition?, indexedAt: Date?,
                    createdAt: Date?, viewer: ViewerStateDefinition? = nil, labels: [ComAtprotoLexicon.Label.LabelDefinition]? = nil,
                    pinnedPost: ComAtprotoLexicon.Repository.StrongReference?, verificationState: VerificationStateDefinition? = nil,
                    status: StatusViewDefinition? = nil) {
            self.actorDID = actorDID
            self.actorHandle = actorHandle
            self.displayName = displayName
            self.description = description
            self.avatarImageURL = avatarImageURL
            self.bannerImageURL = bannerImageURL
            self.followerCount = followerCount
            self.followCount = followCount
            self.postCount = postCount
            self.associated = associated
            self.joinedViaStarterPack = joinedViaStarterPack
            self.indexedAt = indexedAt
            self.createdAt = createdAt
            self.viewer = viewer
            self.labels = labels
            self.pinnedPost = pinnedPost
            self.verificationState = verificationState
            self.status = status
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.actorDID = try container.decode(String.self, forKey: .actorDID)
            self.actorHandle = try container.decode(String.self, forKey: .actorHandle)
            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.avatarImageURL = try container.decodeIfPresent(URL.self, forKey: .avatarImageURL)
            self.bannerImageURL = try container.decodeIfPresent(URL.self, forKey: .bannerImageURL)
            self.followerCount = try container.decodeIfPresent(Int.self, forKey: .followerCount)
            self.followCount = try container.decodeIfPresent(Int.self, forKey: .followCount)
            self.postCount = try container.decodeIfPresent(Int.self, forKey: .postCount)
            self.joinedViaStarterPack = try container.decodeIfPresent(AppBskyLexicon.Graph.StarterPackViewBasicDefinition.self, forKey: .joinedViaStarterPack)
            self.associated = try container.decodeIfPresent(AppBskyLexicon.Actor.ProfileAssociatedDefinition.self, forKey: .associated)
            self.indexedAt = try container.decodeDateIfPresent(forKey: .indexedAt)
            self.createdAt = try container.decodeDateIfPresent(forKey: .createdAt)
            self.viewer = try container.decodeIfPresent(AppBskyLexicon.Actor.ViewerStateDefinition.self, forKey: .viewer)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
            self.pinnedPost = try container.decodeIfPresent(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .pinnedPost)
            self.verificationState = try container.decodeIfPresent(VerificationStateDefinition.self, forKey: .verificationState)
            self.status = try container.decodeIfPresent(StatusViewDefinition.self, forKey: .status)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.actorDID, forKey: .actorDID)
            try container.encode(self.actorHandle, forKey: .actorHandle)
            try container.truncatedEncodeIfPresent(self.displayName, forKey: .displayName, upToCharacterLength: 64)
            try container.truncatedEncodeIfPresent(self.description, forKey: .description, upToCharacterLength: 256)
            try container.encodeIfPresent(self.avatarImageURL, forKey: .avatarImageURL)
            try container.encodeIfPresent(self.bannerImageURL, forKey: .bannerImageURL)
            try container.encodeIfPresent(self.followerCount, forKey: .followerCount)
            try container.encodeIfPresent(self.followCount, forKey: .followCount)
            try container.encodeIfPresent(self.postCount, forKey: .postCount)
            try container.encodeIfPresent(self.associated, forKey: .associated)
            try container.encodeIfPresent(self.joinedViaStarterPack, forKey: .joinedViaStarterPack)
            try container.encodeDateIfPresent(self.indexedAt, forKey: .indexedAt)
            try container.encodeDateIfPresent(self.createdAt, forKey: .createdAt)
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.pinnedPost, forKey: .pinnedPost)
            try container.encodeIfPresent(self.verificationState, forKey: .verificationState)
            try container.encodeIfPresent(self.status, forKey: .status)
        }
        
        enum CodingKeys: String, CodingKey {
            case actorDID = "did"
            case actorHandle = "handle"
            case displayName
            case description
            case avatarImageURL = "avatar"
            case bannerImageURL = "banner"
            case followerCount = "followersCount"
            case followCount = "followsCount"
            case postCount = "postsCount"
            case joinedViaStarterPack
            case associated
            case indexedAt
            case createdAt
            case viewer
            case labels
            case pinnedPost
            case verificationState = "verification"
            case status
        }
    }

    /// A definition model for an actor's associated profile.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileAssociatedDefinition: Sendable, Codable, Equatable, Hashable {

        /// The number of lists associated with the user. Optional.
        public let lists: Int?

        /// The number of feed generators associated with the user. Optional.
        public let feedGenerators: Int?

        /// The number of starter packs associated with the user. Optional.
        public let starterPacks: Int?

        /// Indicates whether the user account is a labeler. Optional.
        public let isActorLabeler: Bool?

        ///
        public let chats: ProfileAssociatedChatDefinition?

        enum CodingKeys: String, CodingKey {
            case lists
            case feedGenerators = "feedgens"
            case starterPacks
            case isActorLabeler = "labeler"
            case chats = "chat"
        }
    }

    /// A definition model for an actor's associated chat profile.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ProfileAssociatedChatDefinition: Sendable, Codable, Equatable, Hashable {

        /// Indicates what messages can be allowed into the user account's chat inbox.
        public let allowIncoming: String

        enum CodingKeys: String, CodingKey {
            case allowIncoming
        }

        /// Indicates what messages can be allowed into the user account's chat inbox.
        public enum AllowIncoming: String, Codable {

            /// Indicates that all messages can be allowed in the inbox with no restrictions.
            case allow

            /// Indicates that no messages can be allowed in the inbox.
            case none

            /// Indicates that all messages can be allowed if it belongs to someone the
            /// user account is following the owner of the message.
            case following
        }
    }

    /// A definition model for an actor viewer state.
    ///
    /// - Note: From the AT Protocol specification: "Metadata about the requesting account's
    /// relationship with the subject account. Only has meaningful content for authed requests."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ViewerStateDefinition: Sendable, Codable, Equatable, Hashable {

        /// Indicates whether the requesting account has been muted by the subject
        /// account. Optional.
        public let isMuted: Bool?

        /// An array of lists that the subject account is muted by.
        public let mutedByArray: AppBskyLexicon.Graph.ListViewBasicDefinition?

        /// Indicates whether the requesting account has been blocked by the subject
        /// account. Optional.
        public let isBlocked: Bool?

        /// A URI which indicates the user has blocked the requesting account.
        public let blockingURI: String?

        /// An array of the subject account's lists.
        public let blockingByArray: AppBskyLexicon.Graph.ListViewBasicDefinition?

        /// A URI which indicates the user is following the requesting account.
        public let followingURI: String?

        /// A URI which indicates the user is being followed by the requesting account.
        public let followedByURI: String?

        /// An array of mutual followers. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The subject's followers whom you
        /// also follow."
        public let knownFollowers: KnownFollowers?

        enum CodingKeys: String, CodingKey {
            case isMuted = "muted"
            case mutedByArray = "mutedByList"
            case isBlocked = "blockedBy"
            case blockingURI = "blocking"
            case blockingByArray = "blockingByList"
            case followingURI = "following"
            case followedByURI = "followedBy"
            case knownFollowers
        }
    }

    /// A definition model for mutual followers.
    ///
    /// - Note: According to the AT Protocol specifications: "The subject's followers whom you
    /// also follow."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct KnownFollowers: Sendable, Codable, Equatable, Hashable {

        /// The number of mutual followers related to the parent structure's specifications.
        public let count: Int

        /// An array of user accounts that follow the viewer.
        ///
        /// - Important: Current maximum length is 5 items.
        public let followers: [ProfileViewBasicDefinition]

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.count, forKey: .count)
            try container.truncatedEncode(self.followers, forKey: .followers, upToArrayLength: 5)
        }
    }

    /// A definition model for verifying user account information attached to this object.
    ///
    /// - Note: According to the AT Protocol specifications: "Represents the verification information about
    /// the user this object is attached to."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct VerificationStateDefinition: Sendable, Codable, Equatable, Hashable {

        /// An array of verifications given by trusted verifiers.
        ///
        /// Untrusted verifiers are not included.
        ///
        /// - Note: According to the AT Protocol specifications: "All verifications issued by trusted
        /// verifiers on behalf of this user. Verifications by untrusted verifiers are not included."
        public let verifications: [VerificationViewDefinition]

        /// The status as a verified user account.
        ///
        /// - Note: According to the AT Protocol specifications: "he user's status as a verified account."
        public let verifiedStatus: VerifiedStatus

        /// The status as a trusted verifier user account.
        ///
        /// - Note: According to the AT Protocol specifications: "The user's status as a trusted verifier."
        public let trustedVerifiedStatus: TrustedVerifiedStatus

        enum CodingKeys: String, CodingKey {
            case verifications
            case verifiedStatus = "verifiedStatus"
            case trustedVerifiedStatus = "trustedVerifierStatus"
        }

        // Enums
        /// The status as a verified user account.
        public enum VerifiedStatus: String, Sendable, Codable {

            /// The user account is verified.
            case valid

            /// The user account has an invalid verification.
            case invalid

            /// The user account is not verified.
            case none
        }

        /// The status as a trusted verifier user account.
        public enum TrustedVerifiedStatus: String, Sendable, Codable {

            /// The user account is verified.
            case valid

            /// The user account has an invalid verification.
            case invalid

            /// The user account is not verified.
            case none
        }
    }

    /// A definition model for a verification.
    ///
    /// - Note: According to the AT Protocol specifications: "An individual verification for an
    /// associated subject."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct VerificationViewDefinition: Sendable, Codable, Equatable, Hashable {

        /// The user account who verified this.
        ///
        /// - Note: According to the AT Protocol specifications: "The user who issued this verification."
        public let issuerDID: String

        /// The URI of the verification.
        ///
        /// - Note: According to the AT Protocol specifications: "The AT-URI of the verification record."
        public let uri: String

        /// Determines if the verification is valid.
        ///
        /// - Note: According to the AT Protocol specifications: "True if the verification passes
        /// validation, otherwise false."
        public let isValid: Bool

        /// The date and time the verification was issued.
        ///
        /// - Note: According to the AT Protocol specifications: "Timestamp when the verification
        /// was created."
        public let createdAt: Date

        public init(issuerDID: String, uri: String, isValid: Bool, createdAt: Date) {
            self.issuerDID = issuerDID
            self.uri = uri
            self.isValid = isValid
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.issuerDID = try container.decode(String.self, forKey: .issuerDID)
            self.uri = try container.decode(String.self, forKey: .uri)
            self.isValid = try container.decode(Bool.self, forKey: .isValid)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.issuerDID, forKey: .issuerDID)
            try container.encode(self.uri, forKey: .uri)
            try container.encode(self.isValid, forKey: .isValid)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case issuerDID = "issuer"
            case uri
            case isValid
            case createdAt
        }
    }

    /// A definition model for preferences.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public typealias PreferencesDefinition = [ATUnion.ActorPreferenceUnion]

    /// A definition model for an "Adult Content" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct AdultContentPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#adultContentPref"

        /// Indicates whether the user will be able to see adult content in their feed. Set to
        /// `false` by default.
        public var isAdultContentEnabled: Bool = false

        public init(isAdultContentEnabled: Bool) {
            self.isAdultContentEnabled = isAdultContentEnabled
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case isAdultContentEnabled = "enabled"
        }
    }

    /// A definition model for a "Content Label" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ContentLabelPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#contentLabelPref"

        /// The decentralized identifier of the labeler that this preference applies to.
        ///
        /// - Note: If this field is empty, then the preferences apply to all labels.
        ///
        /// - Note: According to the AT Protocol specifications: "Which labeler does this
        /// preference apply to? If undefined, applies globally."
        public let did: String?

        /// The name of the content label.
        public let label: String

        /// Indicates the visibility of the label's content.
        public let visibility: Visibility

        public init(did: String?, label: String, visibility: Visibility) {
            self.did = did
            self.label = label
            self.visibility = visibility
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case did = "Did"
            case label
            case visibility
        }

        /// Determines how visible a label's content is.
        public enum Visibility: String, Sendable, Codable {

            /// Indicates the content can be ignored.
            case ignore

            /// Indicates the content can be seen without restriction.
            case show

            /// Indicates the content can be seen, but will ask if the user wants to view it.
            case warn

            /// Indicates the content is fully invisible by the user.
            case hide
        }
    }

    /// A definition model for a saved feed.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct SavedFeed: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#savedFeed"

        /// The ID for the saved feed.
        public let feedID: String

        /// The type of feed generator is.
        ///
        /// This is usually referring to the location of the feed in context to the
        /// user account's choice of placement within Bluesky.
        public let feedType: FeedType

        /// The value of the saved feed generator.
        public let value: String

        /// Indicated whether the saved feed generator is pinned.
        public let isPinned: Bool

        /// The type of feed generator.
        ///
        /// This is usually referring to the location of the feed in context to the
        /// user account's choice of placement within Bluesky.
        public enum FeedType: String, Sendable, Codable {

            /// Indicates the feed generator resides only in the "Feeds" section of Bluesky.
            case feed

            /// Indicates the feed generator additionally resides in a list.
            case list

            /// Indicates the feed generator additionally resides within the
            /// user account's timeline.
            case timeline
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case feedID = "id"
            case feedType = "type"
            case value
            case isPinned = "pinned"
        }
    }

    /// A definition model for version 2 of a "Saved Feeds" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct SavedFeedPreferencesVersion2Definition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#savedFeedsPrefV2"

        /// An array of saved feed generators.
        public let items: [SavedFeed]

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case items
        }
    }

    /// A definition model for a "Saved Feeds" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct SavedFeedsPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#savedFeedsPref"

        /// An array of feed URIs that have been saved and pinned.
        public let pinned: [String]

        /// An array of feed URIs that have been saved.
        public let saved: [String]

        /// The index number of the timeline for the list of feeds. Optional.
        public var timelineIndex: Int?

        public init(pinned: [String], saved: [String], timelineIndex: Int?) {
            self.pinned = pinned
            self.saved = saved
            self.timelineIndex = timelineIndex
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case pinned
            case saved
            case timelineIndex
        }
    }

    /// A definition model for a "Personal Details" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct PersonalDetailsPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#personalDetailsPref"

        /// The birth date of the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "The birth date of account owner."
        public var birthDate: Date?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.birthDate = try container.decodeDateIfPresent(forKey: .birthDate)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.birthDate, forKey: .birthDate)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case birthDate
        }
    }

    /// A definition model for a "Feed View" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct FeedViewPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#feedViewPref"

        /// The feed's identifier (typically the URI).
        ///
        /// - Note:From the AT Protocol specification: "The URI of the feed, or an identifier
        /// which describes the feed."
        public let feedURI: String

        /// Indicates whether the replies are hidden from the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide replies in the feed."
        public let areRepliesHidden: Bool?

        /// Indicates whether replies from users you don't follow are hidden from
        /// the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide replies in the feed if they are not
        /// by followed users."
        public let areUnfollowedRepliesHidden: Bool?

        /// Indicates how many likes a post needs in order for the user to see
        /// the reply. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide replies in the feed if they do not
        /// have this number of likes."
        public let hideRepliesByLikeCount: Int?

        /// Indicates whether reposts are hidden from the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide reposts in the feed."
        public let areRepostsHidden: Bool?

        /// Indicates whether quote posts are hidden from the user. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Hide quote posts in the feed."
        public let areQuotePostsHidden: Bool?

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case feedURI = "feed"
            case areRepliesHidden = "hideReplies"
            case areUnfollowedRepliesHidden = "hideRepliesByUnfollowed"
            case hideRepliesByLikeCount
            case areRepostsHidden = "hideReposts"
            case areQuotePostsHidden = "hideQuotePosts"
        }
    }

    /// A definition model for a "Thread View" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct ThreadViewPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#threadViewPref"

        /// The sorting mode of a thread. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Sorting mode for threads."
        public let sortingMode: SortingMode?

        /// Indicates whether users you follow are prioritized over other users. Optional.
        ///
        /// - Note: From the AT Protocol specification: "Show followed users at the top of
        /// all replies."
        public let areFollowedUsersPrioritized: Bool?

        /// The sorting mode for a thread.
        public enum SortingMode: String, Sendable, Codable {

            /// Indicates the thread will be sorted from the oldest post.
            case oldest

            /// Indicates the thread will be sorted from the newest post.
            case newest

            /// Indicates the thread will be sorted from the posts with the most number
            /// of likes.
            case mostLikes = "most-likes"

            /// Indicates the thread will be completely random.
            case random

            /// Indicates the threads are sorted by an algorithm that balances engagement with recency.
            /// - SeeAlso: Inpired by [Lemmy's algorithm][lemmy]. You can view Bluesky's current
            /// implementation in their [repo][bsky_repo].
            ///
            /// [lemmy]:https://join-lemmy.org/docs/contributors/07-ranking-algo.html
            /// [bsky_repo]:https://github.com/bluesky-social/social-app/blob/c6d26a0a9c6606cccaee38adb535be257f19809d/src/state/queries/post-thread.ts#L312
            case hotness
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case sortingMode = "sort"
            case areFollowedUsersPrioritized = "prioritizeFollowedUsers"
        }
    }

    /// A definition model for an "Interest View" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct InterestViewPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#interestsPref"

        /// An array of interest tags.
        ///
        /// - Note: According to AT Protocol's specifications: "A list of tags which describe the
        /// account owner's interests gathered during onboarding."
        ///
        /// - Important: Current maximum limit is 100 items. Current maximum length for each item
        /// name is 64 characters.
        public let tags: [String]

        public init(tags: [String]) {
            self.tags = tags
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.tags = try container.decode([String].self, forKey: .tags)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.truncatedEncode(self.tags, forKey: .tags, upToCharacterLength: 64, upToArrayLength: 100)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case tags
        }
    }

    /// A definition model for the muted word's target.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public enum MutedWordTarget: Sendable, Codable {

        /// Indicates the muted word is within the content itself.
        case content

        /// Indicates the muted word is a tag.
        case tag

        /// Indicates the muted word is located at an unknown area.
        ///
        /// This case shouldn't be used. If it does appear, then Bluesky may have updated
        /// something that ATProtoKit doesn't yet recognize.
        case other(String)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            let value = try container.decode(String.self)

            switch value {
                case "content":
                    self = .content
                case "tag":
                    self = .tag
                default:
                    self = .other(value)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
                case .content:
                    try container.encode("content")
                case .tag:
                    try container.encode("tag")
                case .other(let other):
                    // Truncate `other` to 640 characters before decoding
                    // `maxGraphemes`'s limit is 64, but `String.count` should respect that limit
                    let truncatedOther = other.truncated(toLength: 640)
                    try container.encode(truncatedOther)
            }
        }
    }

    /// A definition model for a muted word.
    ///
    /// - Note: According to the AT Protocol specifications: "A word that the account owner
    /// has muted."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct MutedWord: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#mutedWord"

        /// The ID of the muted word.
        public let id: String?

        /// The word to mute.
        public let value: String

        /// An array of intended targets for the muted word.
        public let targets: [MutedWordTarget]

        /// Determines whether the muted word applies to all or a select array of user accounts.
        ///
        /// If this field if left as `nil`, then the muted word will apply to all user accounts.
        ///
        /// - Note: According to the AT Protocol specifications: ""Groups of users to apply the
        /// muted word to. If undefined, applies to all users."
        public let actorTarget: ActorTarget?

        /// The date and time the muted word will no longer be in the user account's list.
        ///
        /// - Note: According to the AT Protocol specifications: "The date and time at which the
        /// muted word will expire and no longer be applied."
        public let expiresAt: Date?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decodeIfPresent(String.self, forKey: .id)
            self.value = try container.decode(String.self, forKey: .value)
            self.targets = try container.decode([AppBskyLexicon.Actor.MutedWordTarget].self, forKey: .targets)
            self.actorTarget = try container.decodeIfPresent(AppBskyLexicon.Actor.MutedWord.ActorTarget.self, forKey: .actorTarget)
            self.expiresAt = try container.decodeDateIfPresent(forKey: .expiresAt)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.id, forKey: .id)
            try container.truncatedEncode(self.value, forKey: .value, upToCharacterLength: 100)
            try container.encode(self.targets, forKey: .targets)
            try container.encodeIfPresent(self.actorTarget, forKey: .actorTarget)
            try container.encodeDateIfPresent(self.expiresAt, forKey: .expiresAt)
        }

        enum CodingKeys: CodingKey {
            case id
            case value
            case targets
            case actorTarget
            case expiresAt
        }

        /// An array of user accounts that the muted word applies to.
        public enum ActorTarget: String, Sendable, Codable {

            /// The muted word applies to everyone.
            case all

            /// The muted word applies to everyone but a select array of user accounts.
            case excludeFollowing = "exclude-following"
        }
    }

    /// A definition model for a "Muted Words" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct MutedWordsPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#mutedWordsPref"

        /// An array of items the user has muted.
        ///
        /// - Note: According to the AT Protocol specifications: "A list of words the account
        /// owner has muted."
        public let items: [MutedWord]

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case items
        }
    }

    /// A definition model for a "Hidden Posts" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct HiddenPostsPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#hiddenPostsPref"

        /// An array of URIs related to posts that the user wants to hide.
        ///
        /// - Note: According to the AT Protocol specifications: "A list of URIs of posts the
        /// account owner has hidden."
        public let items: [String]

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case items
        }
    }

    /// A definition model for a "Labelers" preference.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct LabelersPreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#labelersPref"

        /// An array of labeler items.
        public let labelers: [LabelersPreferenceItem]

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case labelers
        }
    }

    /// A definition model for a labeler item.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct LabelersPreferenceItem: Sendable, Codable {

        /// The decentralized identifier (DID) of the labeler.
        public let did: String

        enum CodingKeys: String, CodingKey {
            case did
        }
    }

    /// A definition model for Bluesky app-specific states.
    ///
    /// - Important: Do not use this at all, as this is specific to the Bluesky app.
    ///
    /// - Note: According to the AT Protocol specifications: "A grab bag of state that's specific
    /// to the bsky.app program. Third-party apps shouldn't use this."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct BskyAppStatePreferencesDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#bskyAppStatePref"

        /// An active progress guide. Optional.
        public let activeProgressGuide: String?

        /// An array of elements that the user will see. Optional.
        ///
        /// - Important: Current maximum limit is 1,000 items. Current maximum length for each
        /// item name is 100 characters.
        public let queuedNudges: [String]?

        /// An array of NUXs (New User Experiences). Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Storage for NUXs the user
        /// has encountered."
        public let nuxs: [NUXDefinition]?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.activeProgressGuide, forKey: .activeProgressGuide)
            try container.truncatedEncodeIfPresent(self.queuedNudges, forKey: .queuedNudges, upToCharacterLength: 100, upToArrayLength: 1_000)
            try container.truncatedEncodeIfPresent(self.nuxs, forKey: .nuxs, upToArrayLength: 100)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case activeProgressGuide
            case queuedNudges
            case nuxs
        }
    }

    /// A definition model for a progress guide.
    ///
    /// - Note: According to the AT Protocol specifications: "If set, an active progress guide.
    /// Once completed, can be set to undefined. Should have unspecced fields tracking progress."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct BskyAppProgressGuideDefinition: Sendable, Codable {

        /// The progress guide itself.
        ///
        /// - Important: Current maximum length is 100 characters.
        public let guide: [BskyAppStatePreferencesDefinition]

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.truncatedEncode(self.guide, forKey: .guide, upToArrayLength: 100)
        }
    }

    /// A definition model for a NUX.
    ///
    /// - Note: According to the AT Protocol specifications: "A new user experiences (NUX)
    /// storage object"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct NUXDefinition: Sendable, Codable {

        /// The ID of the NUX.
        public let id: String

        /// Indicated whether the experience was completed.
        public var isCompleted: Bool = false

        /// Data created for the NUX. Optional.
        ///
        /// - Important: Current maximum length is 300 characters.
        ///
        /// - Note: According to the AT Protocol specifications: "Arbitrary data for the NUX.
        /// The structure is defined by the NUX itself. Limited to 300 characters."
        public let data: String?

        /// The date and time the NUX expires. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The date and time at which the
        /// NUX will expire and should be considered completed."
        public let expiresAt: Date?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(String.self, forKey: .id)
            self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
            self.data = try container.decodeIfPresent(String.self, forKey: .data)
            self.expiresAt = try container.decodeDateIfPresent(forKey: .expiresAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.truncatedEncode(self.id, forKey: .id, upToCharacterLength: 100)
            try container.encode(self.isCompleted, forKey: .isCompleted)
            try container.truncatedEncodeIfPresent(self.data, forKey: .data, upToCharacterLength: 300)
            try container.encodeIfPresent(self.expiresAt, forKey: .expiresAt)
        }

        enum CodingKeys: String, CodingKey {
            case id
            case isCompleted = "completed"
            case data
            case expiresAt
        }
    }

    /// A definition model for settings used in terms of how user accounts that are verified or are trusted
    /// verifiers appear.
    ///
    /// - Note: According to the AT Protocol specifications: "Preferences for how verified accounts appear
    /// in the app."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct VerificationPreferenceDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#verificationPrefs"

        /// Determines whether the blue badges for both verified and trusted verifier user accounts
        /// are hidden. Defaults to `false`.
        ///
        /// - Note: According to the AT Protocol specifications: "Hide the blue check badges for verified
        /// accounts and trusted verifiers."
        public let willHideBadges: Bool = false

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case willHideBadges = "hideBadges"
        }
    }

    /// A definition model for default post interaction settings that mirror threadgate and
    /// postgate records when creating new posts.
    ///
    /// - Note: According to the AT Protocol specifications: "Default post interaction settings
    /// for the account. These values should be applied as default values when creating new posts.
    /// These refs should mirror the threadgate and postgate records exactly."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct PostInteractionSettingsPreferenceDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.actor.defs#postInteractionSettingsPref"

        /// An array of rules that determines who can reply to the user account's posts.
        ///
        /// An empty array prevents any replies. An undefined array allows anyone to reply.
        ///
        /// - Note: According to the AT Protocol specifications: "Matches threadgate record. List of rules
        /// defining who can reply to this users posts. If value is an empty array, no one can reply. If
        /// value is undefined, anyone can reply."
        public let threadgateAllowRules: [ATUnion.ActorPostInteractionSettingsPreferencesUnion]

        /// An array of rules that determines the default settings for determining who can embed the post.
        ///
        /// - Note: According to the AT Protocol specifications: "Matches postgate record. List of rules
        /// defining who can embed this users posts. If value is an empty array or is undefined, no
        /// particular rules apply and anyone can embed."
        public let postgateEmbeddingRules: [String]

        public init(threadgateAllowRules: [ATUnion.ActorPostInteractionSettingsPreferencesUnion], postgateEmbeddingRules: [String]) {
            self.threadgateAllowRules = threadgateAllowRules
            self.postgateEmbeddingRules = postgateEmbeddingRules
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.threadgateAllowRules = try container.decode([ATUnion.ActorPostInteractionSettingsPreferencesUnion].self, forKey: .threadgateAllowRules)
            self.postgateEmbeddingRules = try container.decode([String].self, forKey: .postgateEmbeddingRules)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.truncatedEncode(self.threadgateAllowRules, forKey: .threadgateAllowRules, upToArrayLength: 5)
            try container.truncatedEncode(self.postgateEmbeddingRules, forKey: .postgateEmbeddingRules, upToArrayLength: 5)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case threadgateAllowRules
            case postgateEmbeddingRules
        }

        // Unions
        /// A reference containing rules for embedding posts.
        public enum PostgateEmbeddingRulesUnion: Sendable, Codable {

            /// A rule saying that embedding posts is not allowed at all.
            case disabledRule(AppBskyLexicon.Feed.PostgateRecord.DisableRule)

            public init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(AppBskyLexicon.Feed.PostgateRecord.DisableRule.self) {
                    self = .disabledRule(value)
                } else {
                    throw DecodingError.typeMismatch(
                        PostgateEmbeddingRulesUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown PostgateEmbeddingRulesUnion type"))
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .disabledRule(let value):
                        try container.encode(value)
                }
            }
        }
    }

    /// A definition model for a status view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/defs.json
    public struct StatusViewDefinition: Sendable, Codable, Equatable, Hashable {

        /// The user account's status.
        ///
        /// - Note: According to the AT Protocol specifications: "The status for the account."
        public let status: StatusViewDefinition.Status

        /// The record related to the status.
        public let record: UnknownType

        /// The embedded content related to the status. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "An optional embed associated with
        /// the status."
        public let embed: EmbedUnion?

        /// The date and time of the expiration of the status. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The date when this status will expire.
        /// The application might choose to no longer return the status after expiration"
        public let expiresAt: Date?

        /// Determines whether the status is active. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "True if the status is not expired, false
        /// if it is expired. Only present if expiration was set."
        public let isActive: Bool?

        public init(status: StatusViewDefinition.Status, record: UnknownType, embed: EmbedUnion?, expiresAt: Date?, isActive: Bool?) {
            self.status = status
            self.record = record
            self.embed = embed
            self.expiresAt = expiresAt
            self.isActive = isActive
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.status = try container.decode(StatusViewDefinition.Status.self, forKey: .status)
            self.record = try container.decode(UnknownType.self, forKey: .record)
            self.embed = try container.decodeIfPresent(EmbedUnion.self, forKey: .embed)
            self.expiresAt = try container.decodeDateIfPresent(forKey: .expiresAt)
            self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.status, forKey: .status)
            try container.encode(self.record, forKey: .record)
            try container.encodeIfPresent(self.embed, forKey: .embed)
            try container.encodeDateIfPresent(self.expiresAt, forKey: .expiresAt)
            try container.encodeIfPresent(self.isActive, forKey: .isActive)
        }

        enum CodingKeys: CodingKey {
            case status
            case record
            case embed
            case expiresAt
            case isActive
        }

        // Enums
        /// The status of the user account.
        public enum Status: Sendable, Codable, Equatable, Hashable, ExpressibleByStringLiteral {

            /// The status of the user account is "live."
            ///
            /// - Note: According to the AT Protocol specifications: "Advertises an account as currently
            /// offering live content."
            case live

            /// An unknown value that the object may contain.
            case unknown(String)

            /// Provides the raw string value for encoding, decoding, and comparison.
            public var rawValue: String {
                switch self {
                    case .live:
                        return "app.bsky.actor.status#live"
                    case .unknown(let value):
                        return value
                }
            }

            public init(stringLiteral value: String) {
                self = .unknown(value)
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                switch value {
                    case "app.bsky.actor.status#live":
                        self = .live
                    default:
                        self = .unknown(value)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.rawValue)
            }
        }

        // Unions
        /// A reference containing the list of embeds..
        public enum EmbedUnion: Sendable, Codable, Equatable, Hashable {

            /// An external embed view.
            case externalView(AppBskyLexicon.Embed.ExternalDefinition.View)

            public init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()

                if let value = try? container.decode(AppBskyLexicon.Embed.ExternalDefinition.View.self) {
                    self = .externalView(value)
                } else {
                throw DecodingError.typeMismatch(
                    EmbedUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown EmbedUnion type"))
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .externalView(let value):
                        try container.encode(value)
                }
            }
        }
    }
}
