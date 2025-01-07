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
    public struct LabelerViewDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.labeler.defs#labelerView"
        
        /// The URI of the labeler.
        public let uri: String

        /// The CID hash of the labeler.
        public let cid: String

        /// The creator of the labeler.
        public let creator: AppBskyLexicon.Actor.ProfileViewDefinition

        /// The number of likes for the labeler. Optional.
        public let likeCount: Int?

        /// The viewer state of the labeler. Optional.
        public let viewer: LabelerViewerStateDefinition?

        /// The date and time the labeler was last indexed.
        public let indexedAt: Date

        /// An array of labels. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        public init(uri: String, cid: String, creator: AppBskyLexicon.Actor.ProfileViewDefinition, likeCount: Int?,
                    viewer: LabelerViewerStateDefinition?, indexedAt: Date, labels: [ComAtprotoLexicon.Label.LabelDefinition]?) {
            self.uri = uri
            self.cid = cid
            self.creator = creator
            self.likeCount = likeCount
            self.viewer = viewer
            self.indexedAt = indexedAt
            self.labels = labels
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let decodedType = try container.decode(String.self, forKey: .type)
            if decodedType != type {
                throw DecodingError.typeMismatch(LabelerViewDefinition.self, .init(codingPath: [CodingKeys.type], debugDescription: "type did not match expected type \(type)"))
            }

            self.uri = try container.decode(String.self, forKey: .uri)
            self.cid = try container.decode(String.self, forKey: .cid)
            self.creator = try container.decode(AppBskyLexicon.Actor.ProfileViewDefinition.self, forKey: .creator)
            self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
            self.viewer = try container.decodeIfPresent(AppBskyLexicon.Labeler.LabelerViewerStateDefinition.self, forKey: .viewer)
            self.indexedAt = try decodeDate(from: container, forKey: .indexedAt)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
        }
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.uri, forKey: .uri)
            try container.encode(self.cid, forKey: .cid)
            try container.encode(self.creator, forKey: .creator)

            // Assuming `likeCount` is not nil, only encode it if it's 0 or higher
            if let likeCount = self.likeCount, likeCount >= 0 {
                try container.encode(likeCount, forKey: .likeCount)
            }
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try encodeDate(self.indexedAt, with: &container, forKey: .indexedAt)
            try container.encodeIfPresent(self.labels, forKey: .labels)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case uri
            case cid
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
    public struct LabelerViewDetailedDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.labeler.defs#labelerViewDetailed"

        /// The URI of the labeler.
        public let uri: String

        /// The CID hash of the labeler.
        public let cid: String

        /// The creator of the labeler.
        public let creator: AppBskyLexicon.Actor.ProfileViewDefinition

        /// A list of policies by the labeler.
        public let policies: LabelerPolicies

        /// The number of likes for the labeler. Optional.
        public let likeCount: Int?

        /// The viewer state of the labeler. Optional.
        public let viewer: AppBskyLexicon.Labeler.LabelerViewerStateDefinition?

        /// The date and time the labeler was last indexed.
        public let indexedAt: Date

        /// An array of labels. Optional.
        public let labels: [ComAtprotoLexicon.Label.LabelDefinition]?

        public init(uri: String, cid: String, creator: AppBskyLexicon.Actor.ProfileViewDefinition, policies: LabelerPolicies,
                    likeCount: Int?, viewer: AppBskyLexicon.Labeler.LabelerViewerStateDefinition?, indexedAt: Date,
                    labels: [ComAtprotoLexicon.Label.LabelDefinition]?) {
            self.uri = uri
            self.cid = cid
            self.creator = creator
            self.policies = policies
            self.likeCount = likeCount
            self.viewer = viewer
            self.indexedAt = indexedAt
            self.labels = labels
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.uri = try container.decode(String.self, forKey: .uri)
            self.cid = try container.decode(String.self, forKey: .cid)
            self.creator = try container.decode(AppBskyLexicon.Actor.ProfileViewDefinition.self, forKey: .creator)
            self.policies = try container.decode(AppBskyLexicon.Labeler.LabelerPolicies.self, forKey: .policies)
            self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
            self.viewer = try container.decodeIfPresent(AppBskyLexicon.Labeler.LabelerViewerStateDefinition.self, forKey: .viewer)
            self.indexedAt = try decodeDate(from: container, forKey: .indexedAt)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.LabelDefinition].self, forKey: .labels)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.uri, forKey: .uri)
            try container.encode(self.cid, forKey: .cid)
            try container.encode(self.creator, forKey: .creator)
            try container.encode(self.policies, forKey: .policies)

            // Assuming `likeCount` is not nil, only encode it if it's 0 or higher
            if let likeCount = self.likeCount, likeCount >= 0 {
                try container.encode(likeCount, forKey: .likeCount)
            }
            try container.encodeIfPresent(self.viewer, forKey: .viewer)
            try encodeDate(self.indexedAt, with: &container, forKey: .indexedAt)
            try container.encodeIfPresent(self.labels, forKey: .labels)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case uri
            case cid
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
    public struct LabelerViewerStateDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.labeler.defs#labelerViewerState"

        /// The URI of the like record, if the user liked the labeler.
        public let likeURI: String

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case likeURI = "like"
        }
    }

    /// A definition model for a labeler's policies.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.labeler.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/defs.json
    public struct LabelerPolicies: Sendable, Codable, Equatable, Hashable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.labeler.defs#labelerPolicies"

        /// An array of the labeler-published values.
        ///
        /// - Note: According to the AT Protocol specifications: "The label values which this
        /// labeler publishes. May include global or custom labels."
        public let labelValues: [ComAtprotoLexicon.Label.LabelValueDefinition]

        /// An array of labeler-created labels. Optional.
        ///
        /// Labels made in here will override global definitions.
        ///
        /// - Note: According to the AT Protocol specifications: "Label values created by this labeler
        /// and scoped exclusively to it. Labels defined here will override global label definitions
        /// for this labeler."
        public let labelValueDefinitions: [ComAtprotoLexicon.Label.LabelValueDefinition]?

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case labelValues
            case labelValueDefinitions
        }
    }
}
