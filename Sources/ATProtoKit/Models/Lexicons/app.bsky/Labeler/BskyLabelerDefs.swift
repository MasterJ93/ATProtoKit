//
//  BskyLabelerDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

/// A data model definition for a labeler view.
///
/// - SeeAlso: This is based on the [`app.bsky.labeler.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/defs.json
public struct LabelerView: Codable {
    /// The URI of the labeler.
    public let labelerURI: String
    /// The CID hash of the labeler.
    public let labelerCIDHash: String
    /// The creator of the labeler.
    public let creator: ActorProfileView
    /// The number of likes for the labeler. Optional.
    public let likeCount: Int?
    /// The viewer state of the labeler. Optional.
    public let viewer: LabelerViewerState?
    /// The date and time the labeler was last indexed.
    @DateFormatting public var indexedAt: Date
    /// An array of labels. Optional.
    public let labels: [Label]?

    public init(labelerURI: String, labelerCIDHash: String, creator: ActorProfileView, likeCount: Int?, viewer: LabelerViewerState?, indexedAt: Date, labels: [Label]?) {
        self.labelerURI = labelerURI
        self.labelerCIDHash = labelerCIDHash
        self.creator = creator
        self.likeCount = likeCount
        self.viewer = viewer
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        self.labels = labels
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.labelerURI = try container.decode(String.self, forKey: .labelerURI)
        self.labelerCIDHash = try container.decode(String.self, forKey: .labelerCIDHash)
        self.creator = try container.decode(ActorProfileView.self, forKey: .creator)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
        self.viewer = try container.decodeIfPresent(LabelerViewerState.self, forKey: .viewer)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
    }

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

/// A data model definition for a detailed labeler view.
///
/// - SeeAlso: This is based on the [`app.bsky.labeler.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/defs.json
public struct LabelerViewDetailed: Codable {
    /// The URI of the labeler.
    public let labelerURI: String
    /// The CID hash of the labeler.
    public let labelerCIDHash: String
    /// The creator of the labeler.
    public let creator: ActorProfileView
    /// A list of policies by the labeler.
    public let policies: LabelerPolicies
    /// The number of likes for the labeler. Optional.
    public let likeCount: Int?
    /// The viewer state of the labeler. Optional.
    public let viewer: LabelerViewerState?
    /// The date and time the labeler was last indexed.
    @DateFormatting public var indexedAt: Date
    /// An array of labels. Optional.
    public let labels: [Label]?

    public init(labelerURI: String, labelerCIDHash: String, creator: ActorProfileView, policies: LabelerPolicies, likeCount: Int?, viewer: LabelerViewerState?, indexedAt: Date, labels: [Label]?) {
        self.labelerURI = labelerURI
        self.labelerCIDHash = labelerCIDHash
        self.creator = creator
        self.policies = policies
        self.likeCount = likeCount
        self.viewer = viewer
        self._indexedAt = DateFormatting(wrappedValue: indexedAt)
        self.labels = labels
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.labelerURI = try container.decode(String.self, forKey: .labelerURI)
        self.labelerCIDHash = try container.decode(String.self, forKey: .labelerCIDHash)
        self.creator = try container.decode(ActorProfileView.self, forKey: .creator)
        self.policies = try container.decode(LabelerPolicies.self, forKey: .policies)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
        self.viewer = try container.decodeIfPresent(LabelerViewerState.self, forKey: .viewer)
        self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
    }

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

/// A data model definition for a user account's view state for the labeler.
///
/// - SeeAlso: This is based on the [`app.bsky.labeler.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/defs.json
public struct LabelerViewerState: Codable {
    /// The URI of the like record, if the user liked the labeler.
    public let like: String
}

/// A data model definition for a labeler's policies.
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
    public let labelValues: [LabelValue]
    /// An array of labeler-created labels.
    ///
    /// Labels made in here will override global definitions.
    ///
    /// - Note: According to the AT Protocol specifications: "Label values created by this labeler
    /// and scoped exclusively to it. Labels defined here will override global label definitions
    /// for this labeler."
    public let labelValueDefinitions: [LabelValueDefinition]
}
