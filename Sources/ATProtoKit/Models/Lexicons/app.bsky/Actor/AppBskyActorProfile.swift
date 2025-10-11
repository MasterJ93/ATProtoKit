//
//  AppBskyActorProfile.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Actor {

    /// The main data model definition for an actor.
    ///
    /// - Note: According to the AT Protocol specifications: "A declaration of a Bluesky
    /// account profile."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.profile`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/profile.json
    public struct ProfileRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.actor.profile"

        /// The display name of the profile. Optional.
        ///
        /// - Important: Current maximum length is 64 characters.
        public let displayName: String?

        /// The description of the profile. Optional.
        ///
        /// - Important: Current maximum length is 256 characters.
        ///
        /// - Note: According to the AT Protocol specifications: "Free-form profile
        /// description text."
        public let description: String?

        /// The user account's pronoun preferences. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Free-form pronouns text."
        public let pronouns: String?

        /// The user account's website. Optional.
        public let websiteURL: URL?

        /// The avatar image blob of the profile. Optional.
        ///
        /// - Note: Only JPEGs and PNGs are accepted.
        ///
        /// - Important: Current maximum file size 1,000,000 bytes (1 MB).
        ///
        /// - Note: According to the AT Protocol specifications: "Small image to be displayed next
        /// to posts from account. AKA, 'profile picture'"
        public let avatarBlob: ComAtprotoLexicon.Repository.UploadBlobOutput?

        /// The banner image blob of the profile. Optional.
        ///
        /// - Note: Only JPEGs and PNGs are accepted.
        ///
        /// - Important: Current maximum file size 1,000,000 bytes (1 MB).
        ///
        /// - Note: According to the AT Protocol specifications: "Larger horizontal image to
        /// display behind profile view."
        public let bannerBlob: ComAtprotoLexicon.Repository.UploadBlobOutput?

        /// An array of user-defined labels. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Self-label values, specific to
        /// the Bluesky application, on the overall account."
        public let labels: [LabelsUnion]?

        /// The starter pack the user account used to join Bluesky. Optional.
        public let joinedViaStarterPack: ComAtprotoLexicon.Repository.StrongReference?

        /// A post record that's pinned to the profile. Optional.
        public let pinnedPost: ComAtprotoLexicon.Repository.StrongReference?

        /// The date and time the profile was created. Optional.
        public let createdAt: Date?

        public init(displayName: String?, description: String?, pronouns: String?, websiteURL: URL?,
                    avatarBlob: ComAtprotoLexicon.Repository.UploadBlobOutput?,
                    bannerBlob: ComAtprotoLexicon.Repository.UploadBlobOutput?, labels: [LabelsUnion]?,
                    joinedViaStarterPack: ComAtprotoLexicon.Repository.StrongReference?, pinnedPost: ComAtprotoLexicon.Repository.StrongReference?,
                    createdAt: Date?) {
            self.displayName = displayName
            self.description = description
            self.pronouns = pronouns
            self.websiteURL = websiteURL
            self.avatarBlob = avatarBlob
            self.bannerBlob = bannerBlob
            self.labels = labels
            self.joinedViaStarterPack = joinedViaStarterPack
            self.pinnedPost = pinnedPost
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.pronouns = try container.decodeIfPresent(String.self, forKey: .pronouns)
            self.websiteURL = try container.decodeIfPresent(URL.self, forKey: .websiteURL)
            self.avatarBlob = try container.decodeIfPresent(ComAtprotoLexicon.Repository.UploadBlobOutput.self, forKey: .avatarBlob)
            self.bannerBlob = try container.decodeIfPresent(ComAtprotoLexicon.Repository.UploadBlobOutput.self, forKey: .bannerBlob)
            self.labels = try container.decodeIfPresent([LabelsUnion].self, forKey: .labels)
            self.joinedViaStarterPack = try container.decodeIfPresent(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .joinedViaStarterPack)
            self.pinnedPost = try container.decodeIfPresent(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .pinnedPost)
            self.createdAt = try container.decodeDateIfPresent(forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.truncatedEncodeIfPresent(self.displayName, forKey: .displayName, upToCharacterLength: 64)
            try container.truncatedEncodeIfPresent(self.description, forKey: .description, upToCharacterLength: 256)
            try container.truncatedEncodeIfPresent(self.pronouns, forKey: .pronouns, upToCharacterLength: 20)
            try container.encodeIfPresent(self.websiteURL, forKey: .websiteURL)
            try container.encodeIfPresent(self.avatarBlob, forKey: .avatarBlob)
            try container.encodeIfPresent(self.bannerBlob, forKey: .bannerBlob)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.joinedViaStarterPack, forKey: .joinedViaStarterPack)
            try container.encodeIfPresent(self.pinnedPost, forKey: .pinnedPost)
            try container.encodeDateIfPresent(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case displayName
            case description
            case pronouns
            case websiteURL = "website"
            case avatarBlob = "avatar"
            case bannerBlob = "banner"
            case labels
            case joinedViaStarterPack
            case pinnedPost
            case createdAt
        }

        /// An array of user-defined labels.
        public enum LabelsUnion: ATUnionProtocol, Equatable, Hashable {

            /// A definition model for an array of self-defined labels.
            case selfLabel(ComAtprotoLexicon.Label.SelfLabelsDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "com.atproto.label.defs#selfLabels":
                        self = .selfLabel(try ComAtprotoLexicon.Label.SelfLabelsDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .selfLabel(let value):
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
