//
//  AppBskyLabelerDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Labeler {

    /// A definition model for a labeler view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.labeler.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/defs.json
    public struct LabelerViewDefinition: Codable {

        /// The URI of the labeler.
        public let labelerURI: String

        /// The CID hash of the labeler.
        public let labelerCIDHash: String

        /// The creator of the labeler.
        public let creator: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The number of likes for the labeler. Optional.
        public let likeCount: Int?

        /// The viewer state of the labeler. Optional.
        public let viewer: LabelerViewerStateDefinition?

        /// The date and time the labeler was last indexed.
        @DateFormatting public var indexedAt: Date

        /// An array of labels. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.labelerURI, forKey: .labelerURI)
            try container.encode(self.labelerCIDHash, forKey: .labelerCIDHash)
            try container.encode(self.creator, forKey: .creator)

            // Assuming `likeCount` is not nil, only encode it if it's 0 or higher
            if let likeCount = self.likeCount, likeCount >= 0 {
                try container.encode(likeCount, forKey: .likeCount)
            }
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encode(self._indexedAt, forKey: .indexedAt)
            try container.encodeIfPresent(self.labels, forKey: .labels)
        }

        enum CodingKeys: String, CodingKey {
            case labelerURI = "uri"
            case labelerCIDHash = "cid"
            case creator
            case likeCount
            case viewer
            case indexedAt
            case labels
        }
    }

    /// A definition model for a detailed labeler view.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.labeler.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/defs.json
    public struct LabelerViewDetailedDefinition: Codable {

        /// The URI of the labeler.
        public let labelerURI: String

        /// The CID hash of the labeler.
        public let labelerCIDHash: String

        /// The creator of the labeler.
        public let creator: AppBskyLexicon.Actor.ProfileViewDefinition

        /// A list of policies by the labeler.
        public let policies: LabelerPolicies

        /// The number of likes for the labeler. Optional.
        public let likeCount: Int?

        /// The viewer state of the labeler. Optional.
        public let viewer: AppBskyLexicon.Labeler.LabelerViewerStateDefinition?

        /// The date and time the labeler was last indexed.
        @DateFormatting public var indexedAt: Date

        /// An array of labels. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.labelerURI, forKey: .labelerURI)
            try container.encode(self.labelerCIDHash, forKey: .labelerCIDHash)
            try container.encode(self.creator, forKey: .creator)
            try container.encode(self.policies, forKey: .policies)

            // Assuming `likeCount` is not nil, only encode it if it's 0 or higher
            if let likeCount = self.likeCount, likeCount >= 0 {
                try container.encode(likeCount, forKey: .likeCount)
            }
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try container.encode(self._indexedAt, forKey: .indexedAt)
            try container.encodeIfPresent(self.labels, forKey: .labels)
        }

        enum CodingKeys: String, CodingKey {
            case labelerURI = "uri"
            case labelerCIDHash = "cid"
            case creator
            case policies
            case likeCount
            case viewer
            case indexedAt
            case labels
        }
    }

    /// A definition model for a user account's view state for the labeler.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.labeler.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/defs.json
    public struct LabelerViewerStateDefinition: Codable {

        /// The URI of the like record, if the user liked the labeler.
        public let like: String
    }

    /// A definition model for a labeler's policies.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.labeler.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/defs.json
    public struct LabelerPolicies: Codable {

        /// An array of the labeler-published values.
        ///
        /// - Note: According to the AT Protocol specifications: "The label values which this labeler
        /// publishes. May include global
        /// or custom labels."
        public let labelValues: [ComAtprotoLexicon.Label.LabelValueDefinition]

        /// An array of labeler-created labels.
        ///
        /// Labels made in here will override global definitions.
        ///
        /// - Note: According to the AT Protocol specifications: "Label values created by this labeler
        /// and scoped exclusively to it. Labels defined here will override global label definitions
        /// for this labeler."
        public let labelValueDefinitions: [ComAtprotoLexicon.Label.LabelValueDefinition]
    }
}
