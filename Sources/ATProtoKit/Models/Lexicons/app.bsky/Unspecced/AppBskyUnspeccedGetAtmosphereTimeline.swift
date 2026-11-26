//
//  AppBskyUnspeccedGetAtmosphereTimeline.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for getting the Atmosphere activity timeline.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetAtmosphereTimeline: Sendable, Codable {

        /// A record of an activity.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimeline.json
        public struct ActivityRecord: Sendable, Codable {

            /// The URI of the record.
            public let uri: String

            /// The CID hash of the record.
            public let cid: String

            /// The date and time the record was indexed.
            public let indexedAt: Date

            public init(uri: String, cid: String, indexedAt: Date) {
                self.uri = uri
                self.cid = cid
                self.indexedAt = indexedAt
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.uri, forKey: .uri)
                try container.encode(self.cid, forKey: .cid)
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
            }

            enum CodingKeys: CodingKey {
                case uri
                case cid
                case indexedAt
            }
        }

        /// The viewer state of an activity.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimeline.json
        public struct ViewerState: Sendable, Codable {

            /// Indicates whether the viewer is subscribed.
            public let isSubscribed: Bool

            enum CodingKeys: String, CodingKey {
                case isSubscribed = "subscribed"
            }
        }

        /// A single activity item.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimeline.json
        public struct ActivityItem: Sendable, Codable {

            /// The record of the activity.
            public let record: AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityRecord

            /// The collection of the activity record.
            public let collection: String

            /// The viewer state of the activity.
            public let viewerState: AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ViewerState

            /// An array of related activity groups targeting this item's record. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "Collection-specific activity
            /// references targeting this item's record. Article creations with related activity
            /// remain standalone; only the parent item's view is hydrated."
            public let relatedActivity: [AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityRelatedGroup]?

            /// A strong reference to the Bluesky post associated with the rendered article or
            /// livestream. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The Bluesky post associated with
            /// the rendered article or livestream, as declared by its author. The referenced post may
            /// not be available."
            public let blueskyPostReference: ComAtprotoLexicon.Repository.StrongReference?

            /// The hydrated Bluesky post associated with the rendered article or livestream. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The hydrated Bluesky post
            /// associated with the rendered article or livestream, as declared by its author.
            /// Omitted when the post is unavailable to the viewer."
            public let blueskyPostView: AppBskyLexicon.Feed.PostViewDefinition?

            /// The view of the activity. Optional.
            public let view: ViewUnion?

            enum CodingKeys: String, CodingKey {
                case record
                case collection
                case viewerState
                case relatedActivity
                case blueskyPostReference = "bskyPostRef"
                case blueskyPostView = "viewBskyPost"
                case view
            }

            // Unions
            /// The view of the activity.
            public enum ViewUnion: ATUnionProtocol {

                /// The view of an article.
                case viewArticle(AppBskyLexicon.Embed.ExternalDefinition.ViewArticle)

                /// The view of an article publication.
                case viewArticlePublication(AppBskyLexicon.Embed.ExternalDefinition.ViewArticlePublication)

                /// The view of a gallery.
                case viewGallery(AppBskyLexicon.Embed.ExternalDefinition.ViewGallery)

                /// The view of a livestream.
                case viewLivestream(AppBskyLexicon.Embed.ExternalDefinition.ViewLivestream)

                /// The view of a post.
                case postView(AppBskyLexicon.Feed.PostViewDefinition)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decodeIfPresent(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.embed.external#viewArticle":
                            self = .viewArticle(try AppBskyLexicon.Embed.ExternalDefinition.ViewArticle(from: decoder))
                        case "app.bsky.embed.external#viewArticlePublication":
                            self = .viewArticlePublication(try AppBskyLexicon.Embed.ExternalDefinition.ViewArticlePublication(from: decoder))
                        case "app.bsky.embed.external#viewGallery":
                            self = .viewGallery(try AppBskyLexicon.Embed.ExternalDefinition.ViewGallery(from: decoder))
                        case "app.bsky.embed.external#viewLivestream":
                            self = .viewLivestream(try AppBskyLexicon.Embed.ExternalDefinition.ViewLivestream(from: decoder))
                        case "app.bsky.feed.defs#postView":
                            self = .postView(try AppBskyLexicon.Feed.PostViewDefinition(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type ?? "unknown", dictionary)
                    }
                }

                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .viewArticle(let value):
                            try container.encode(value)
                        case .viewArticlePublication(let value):
                            try container.encode(value)
                        case .viewGallery(let value):
                            try container.encode(value)
                        case .viewLivestream(let value):
                            try container.encode(value)
                        case .postView(let value):
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

        /// A group of activities by one actor in one collection.
        ///
        /// - Note: According to the AT Protocol specifications: "Activities by one actor in one
        /// collection, positioned at the newest group item. Only the newest item is hydrated.
        /// Article creations with related activity remain standalone."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimeline.json
        public struct ActivityActorGroup: Sendable, Codable {

            /// The ID of the group.
            public let id: String

            /// The collection of the group's activities.
            public let collection: String

            /// The date and time the group was indexed.
            public let indexedAt: Date

            /// The decentralized identifier (DID) of the actor.
            public let actorDID: String

            /// The hydrated newest item of the group.
            public let item: AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityItem

            /// An array of URIs of all visible group items.
            ///
            /// - Note: According to the AT Protocol specifications: "All visible group item URIs,
            /// including the hydrated item, in newest-first timeline order."
            public let uris: [String]

            public init(id: String, collection: String, indexedAt: Date, actorDID: String,
                        item: AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityItem, uris: [String]) {
                self.id = id
                self.collection = collection
                self.indexedAt = indexedAt
                self.actorDID = actorDID
                self.item = item
                self.uris = uris
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.id = try container.decode(String.self, forKey: .id)
                self.collection = try container.decode(String.self, forKey: .collection)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
                self.actorDID = try container.decode(String.self, forKey: .actorDID)
                self.item = try container.decode(AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityItem.self, forKey: .item)
                self.uris = try container.decode([String].self, forKey: .uris)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.id, forKey: .id)
                try container.encode(self.collection, forKey: .collection)
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
                try container.encode(self.actorDID, forKey: .actorDID)
                try container.encode(self.item, forKey: .item)
                try container.encode(self.uris, forKey: .uris)
            }

            enum CodingKeys: String, CodingKey {
                case id
                case collection
                case indexedAt
                case actorDID = "actor"
                case item
                case uris
            }
        }

        /// The shared target of grouped activities.
        ///
        /// - Note: According to the AT Protocol specifications: "The shared target of grouped
        /// activities, not an activity itself."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimeline.json
        public struct ActivitySubject: Sendable, Codable {

            /// The URI of the subject.
            public let uri: String

            /// The viewer state of the subject.
            public let viewerState: AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ViewerState

            /// A strong reference to the author's declared Bluesky post for the subject. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The author's declared Bluesky post
            /// for the target. The post may be unavailable."
            public let blueskyPostReference: ComAtprotoLexicon.Repository.StrongReference?

            /// The hydrated Bluesky post declared by the subject's author. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The hydrated Bluesky post
            /// declared by the target's author. Omitted when the post is unavailable to the viewer."
            public let blueskyPostView: AppBskyLexicon.Feed.PostViewDefinition?

            /// The view of the subject.
            public let view: ViewUnion

            enum CodingKeys: String, CodingKey {
                case uri
                case viewerState
                case blueskyPostReference = "bskyPostRef"
                case blueskyPostView = "viewBskyPost"
                case view
            }

            // Unions
            /// The view of the subject.
            public enum ViewUnion: ATUnionProtocol {

                /// The view of an article.
                case viewArticle(AppBskyLexicon.Embed.ExternalDefinition.ViewArticle)

                /// The view of an article publication.
                case viewArticlePublication(AppBskyLexicon.Embed.ExternalDefinition.ViewArticlePublication)

                /// The view of a gallery.
                case viewGallery(AppBskyLexicon.Embed.ExternalDefinition.ViewGallery)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decodeIfPresent(String.self, forKey: .type)

                    switch type {
                        case "app.bsky.embed.external#viewArticle":
                            self = .viewArticle(try AppBskyLexicon.Embed.ExternalDefinition.ViewArticle(from: decoder))
                        case "app.bsky.embed.external#viewArticlePublication":
                            self = .viewArticlePublication(try AppBskyLexicon.Embed.ExternalDefinition.ViewArticlePublication(from: decoder))
                        case "app.bsky.embed.external#viewGallery":
                            self = .viewGallery(try AppBskyLexicon.Embed.ExternalDefinition.ViewGallery(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type ?? "unknown", dictionary)
                    }
                }

                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .viewArticle(let value):
                            try container.encode(value)
                        case .viewArticlePublication(let value):
                            try container.encode(value)
                        case .viewGallery(let value):
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

        /// An unhydrated item in an activity group.
        ///
        /// - Note: According to the AT Protocol specifications: "An unhydrated group item. Its actor
        /// DID is the authority of its record URI."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimeline.json
        public struct ActivityGroupItem: Sendable, Codable {

            /// The record of the activity.
            public let record: AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityRecord

            /// The collection of the activity record.
            public let collection: String
        }

        /// A group of activities targeting the parent item's record.
        ///
        /// - Note: According to the AT Protocol specifications: "Visible activities in one collection
        /// targeting the parent item's record, without a time window. Contains references and
        /// profiles only, not a shared subject or hydrated action views. Buckets follow newest-first
        /// first appearance."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimeline.json
        public struct ActivityRelatedGroup: Sendable, Codable {

            /// The collection of the group's activities.
            public let collection: String

            /// An array of activity references.
            ///
            /// - Note: According to the AT Protocol specifications: "Visible activity references in
            /// newest-first timeline order. Every activity has the bucket's collection."
            public let activities: [AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityGroupItem]

            /// An array of unique actors.
            ///
            /// - Note: According to the AT Protocol specifications: "Unique actors in first-appearance
            /// order among the bucket's activities."
            public let actors: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]
        }

        /// A group of activities by at least two actors sharing a target.
        ///
        /// - Note: According to the AT Protocol specifications: "Activities in one collection sharing a
        /// target, by at least two distinct actors, positioned at the newest group item. Article
        /// recommendations and shares group separately across the returned page without a time
        /// window. Article creations are not subject-group items. Publication subscriptions and
        /// gallery favorites retain age-based grouping windows."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimeline`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimeline.json
        public struct ActivitySubjectGroup: Sendable, Codable {

            /// The ID of the group.
            public let id: String

            /// The collection of the group's activities.
            public let collection: String

            /// The date and time the group was indexed.
            public let indexedAt: Date

            /// The shared target of the group's activities.
            public let subject: AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivitySubject

            /// An array of group items.
            ///
            /// - Note: According to the AT Protocol specifications: "Visible group items in
            /// newest-first timeline order. Every activity has the group's collection."
            public let activities: [AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityGroupItem]

            /// An array of unique actors.
            ///
            /// - Note: According to the AT Protocol specifications: "Unique actors in first-appearance
            /// order among group items. At least two distinct actors are required."
            public let actors: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]

            public init(id: String, collection: String, indexedAt: Date, subject: AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivitySubject,
                        activities: [AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityGroupItem], actors: [AppBskyLexicon.Actor.ProfileViewBasicDefinition]) {
                self.id = id
                self.collection = collection
                self.indexedAt = indexedAt
                self.subject = subject
                self.activities = activities
                self.actors = actors
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.id = try container.decode(String.self, forKey: .id)
                self.collection = try container.decode(String.self, forKey: .collection)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
                self.subject = try container.decode(AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivitySubject.self, forKey: .subject)
                self.activities = try container.decode([AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityGroupItem].self, forKey: .activities)
                self.actors = try container.decode([AppBskyLexicon.Actor.ProfileViewBasicDefinition].self, forKey: .actors)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.id, forKey: .id)
                try container.encode(self.collection, forKey: .collection)
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
                try container.encode(self.subject, forKey: .subject)
                try container.encode(self.activities, forKey: .activities)
                try container.encode(self.actors, forKey: .actors)
            }

            enum CodingKeys: CodingKey {
                case id
                case collection
                case indexedAt
                case subject
                case activities
                case actors
            }
        }
    }

    /// An output model for getting the Atmosphere activity timeline.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the authenticated viewer's
    /// Atmosphere activity timeline. Groups contain visible activities from the returned page."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimeline`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimeline.json
    public struct GetAtmosphereTimelineOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of activities and activity groups.
        public let feed: [FeedUnion]

        // Unions
        /// An activity or an activity group.
        public enum FeedUnion: ATUnionProtocol {

            /// A single activity item.
            case activityItem(AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityItem)

            /// A group of activities by one actor.
            case activityActorGroup(AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityActorGroup)

            /// A group of activities sharing a target.
            case activitySubjectGroup(AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivitySubjectGroup)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "app.bsky.unspecced.getAtmosphereTimeline#activityItem":
                        self = .activityItem(try AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityItem(from: decoder))
                    case "app.bsky.unspecced.getAtmosphereTimeline#activityActorGroup":
                        self = .activityActorGroup(try AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivityActorGroup(from: decoder))
                    case "app.bsky.unspecced.getAtmosphereTimeline#activitySubjectGroup":
                        self = .activitySubjectGroup(try AppBskyLexicon.Unspecced.GetAtmosphereTimeline.ActivitySubjectGroup(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .activityItem(let value):
                        try container.encode(value)
                    case .activityActorGroup(let value):
                        try container.encode(value)
                    case .activitySubjectGroup(let value):
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
