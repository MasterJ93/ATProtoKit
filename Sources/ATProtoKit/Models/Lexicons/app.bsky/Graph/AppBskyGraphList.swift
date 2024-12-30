//
//  AppBskyGraphList.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Graph {

    /// A record model for a list.
    ///
    /// - Note: According to the AT Protocol specifications: "Record representing a list of
    /// accounts (actors). Scope includes both moderation-oriented lists and
    /// curration-oriented lists."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.list`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/list.json
    public struct ListRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.graph.list"

        /// The purpose of the list.
        ///
        /// - Note: According to the AT Protocol specifications: "Defines the purpose of the list
        /// (aka, moderation-oriented or curration-oriented)."
        public let purpose: ListPurpose

        /// The name of the list.
        ///
        /// - Note: According to the AT Protocol specifications: "Display name for list; can not
        /// be empty."
        public let name: String

        /// The description of the list. Optional.
        public let description: String?

        /// An array of facets contained within the description. Optional.
        public let descriptionFacets: [AppBskyLexicon.RichText.Facet]?

        /// The avatar image of the list. Optional.
        ///
        /// - Note: Only JPEGs and PNGs are accepted.
        ///
        /// - Important: Current maximum file size 1,000,000 bytes (1 MB).
        public let avatarImageBlob: ComAtprotoLexicon.Repository.UploadBlobOutput?

        /// The user-defined labels for the list. Optional.
        public let labels: ATUnion.ListLabelsUnion

        /// The date and time the list was created.
        public let createdAt: Date

        public init(purpose: ListPurpose, name: String, description: String?, descriptionFacets: [AppBskyLexicon.RichText.Facet]?,
                    avatarImageBlob: ComAtprotoLexicon.Repository.UploadBlobOutput?, labels: ATUnion.ListLabelsUnion, createdAt: Date) {
            self.purpose = purpose
            self.name = name
            self.description = description
            self.descriptionFacets = descriptionFacets
            self.avatarImageBlob = avatarImageBlob
            self.labels = labels
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.purpose = try container.decode(ListPurpose.self, forKey: .purpose)
            self.name = try container.decode(String.self, forKey: .name)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.descriptionFacets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .descriptionFacets)
            self.avatarImageBlob = try container.decodeIfPresent(ComAtprotoLexicon.Repository.UploadBlobOutput.self, forKey: .avatarImageBlob)
            self.labels = try container.decode(ATUnion.ListLabelsUnion.self, forKey: .labels)
            self.createdAt = try decodeDate(from: container, forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.purpose, forKey: .purpose)
            try container.encode(self.name, forKey: .name)
            try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToCharacterLength: 64)
            try truncatedEncodeIfPresent(self.description, withContainer: &container, forKey: .description, upToCharacterLength: 30)
            try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
            try container.encodeIfPresent(self.avatarImageBlob, forKey: .avatarImageBlob)
            try container.encode(self.labels, forKey: .labels)
            try encodeDate(self.createdAt, with: &container, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case purpose
            case name
            case description
            case descriptionFacets
            case avatarImageBlob = "avatar"
            case labels
            case createdAt
        }
    }
}
