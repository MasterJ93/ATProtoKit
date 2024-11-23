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

        /// The name of the list.
        ///
        /// - Note: According to the AT Protocol specifications: "Display name for list; can not
        /// be empty."
        public let name: String

        /// The purpose of the list.
        ///
        /// - Note: According to the AT Protocol specifications: "Defines the purpose of the list
        /// (aka, moderation-oriented or curration-oriented)."
        public let purpose: ListPurpose

        /// The description of the list. Optional.
        public let description: String?

        /// An array of facets contained within the description. Optional.
        public let descriptionFacets: [AppBskyLexicon.RichText.Facet]?

        /// The avatar image of the list. Optional.
        public let avatarImage: ComAtprotoLexicon.Repository.UploadBlobOutput?

        /// The user-defined labels for the list. Optional.
        public let labels: ATUnion.ListLabelsUnion

        /// The date and time the list was created.
        public let createdAt: Date

        public init(name: String, purpose: ListPurpose, description: String?, descriptionFacets: [AppBskyLexicon.RichText.Facet]?,
                    avatarImage: ComAtprotoLexicon.Repository.UploadBlobOutput?, labels: ATUnion.ListLabelsUnion, createdAt: Date) {
            self.name = name
            self.purpose = purpose
            self.description = description
            self.descriptionFacets = descriptionFacets
            self.avatarImage = avatarImage
            self.labels = labels
            self.createdAt = createdAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decode(String.self, forKey: .name)
            self.purpose = try container.decode(ListPurpose.self, forKey: .purpose)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.descriptionFacets = try container.decodeIfPresent([AppBskyLexicon.RichText.Facet].self, forKey: .descriptionFacets)
            self.avatarImage = try container.decodeIfPresent(ComAtprotoLexicon.Repository.UploadBlobOutput.self, forKey: .avatarImage)
            self.labels = try container.decode(ATUnion.ListLabelsUnion.self, forKey: .labels)
            self.createdAt = try decodeDate(from: container, forKey: .createdAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.name, forKey: .name)
            try container.encode(self.purpose, forKey: .purpose)
            try container.encodeIfPresent(self.description, forKey: .description)
            try container.encodeIfPresent(self.descriptionFacets, forKey: .descriptionFacets)
            try container.encodeIfPresent(self.avatarImage, forKey: .avatarImage)
            try container.encode(self.labels, forKey: .labels)
            try encodeDate(self.createdAt, with: &container, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case name
            case purpose
            case description
            case descriptionFacets
            case avatarImage = "avatar"
            case labels
            case createdAt
        }
    }
}
