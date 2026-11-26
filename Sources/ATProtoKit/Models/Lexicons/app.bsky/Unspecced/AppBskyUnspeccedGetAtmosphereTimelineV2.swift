//
//  AppBskyUnspeccedGetAtmosphereTimelineV2.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for getting the Atmosphere activity timeline (v2).
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    public struct GetAtmosphereTimelineV2: Sendable, Codable {

        /// A single activity with its hydrated subject.
        ///
        /// - Note: According to the AT Protocol specifications: "A single activity with its hydrated
        /// subject. An activity that creates content, such as publishing an article, is always a
        /// standalone item when other activities on the same page target that content; those
        /// activities are attached as relatedActivity. Activities whose subject is unavailable to
        /// the viewer are omitted from the timeline."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimelineV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimelineV2.json
        public struct ActivityItem: Sendable, Codable {

            /// A strong reference to the activity record.
            public let reference: ComAtprotoLexicon.Repository.StrongReference

            /// The collection of the activity record.
            ///
            /// - Note: According to the AT Protocol specifications: "The collection of the activity
            /// record. Ex: site.standard.graph.recommend."
            public let collection: String

            /// The date and time the activity was indexed.
            ///
            /// - Note: According to the AT Protocol specifications: "When the activity was indexed.
            /// Determines the item's position in the feed, even when relatedActivity contains newer
            /// activities."
            public let indexedAt: Date

            /// The decentralized identifier (DID) of the actor.
            public let actorDID: String

            /// The hydrated subject of the activity.
            public let subject: AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubject

            /// An array of activities targeting content created by this activity. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "All available activities on the
            /// same page that target content created by this activity, newest first. Ex:
            /// recommendations of a newly published article. Only present on activities that create
            /// content. Activities targeting content created on an earlier page appear as their own
            /// feed entries instead."
            public let relatedActivity: [AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityItemRelatedActivity]?

            public init(reference: ComAtprotoLexicon.Repository.StrongReference, collection: String, indexedAt: Date, actorDID: String,
                        subject: AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubject,
                        relatedActivity: [AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityItemRelatedActivity]?) {
                self.reference = reference
                self.collection = collection
                self.indexedAt = indexedAt
                self.actorDID = actorDID
                self.subject = subject
                self.relatedActivity = relatedActivity
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.reference = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .reference)
                self.collection = try container.decode(String.self, forKey: .collection)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
                self.actorDID = try container.decode(String.self, forKey: .actorDID)
                self.subject = try container.decode(AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubject.self, forKey: .subject)
                self.relatedActivity = try container.decodeIfPresent([AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityItemRelatedActivity].self, forKey: .relatedActivity)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.reference, forKey: .reference)
                try container.encode(self.collection, forKey: .collection)
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
                try container.encode(self.actorDID, forKey: .actorDID)
                try container.encode(self.subject, forKey: .subject)
                try container.encodeIfPresent(self.relatedActivity, forKey: .relatedActivity)
            }

            enum CodingKeys: String, CodingKey {
                case reference = "ref"
                case collection
                case indexedAt
                case actorDID = "actor"
                case subject
                case relatedActivity
            }
        }

        /// An activity targeting content created by another activity.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimelineV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimelineV2.json
        public struct ActivityItemRelatedActivity: Sendable, Codable {

            /// A strong reference to the activity record.
            public let reference: ComAtprotoLexicon.Repository.StrongReference

            /// The collection of the activity record.
            public let collection: String

            /// The date and time the activity was indexed.
            public let indexedAt: Date

            /// The decentralized identifier (DID) of the actor.
            public let actorDID: String

            public init(reference: ComAtprotoLexicon.Repository.StrongReference, collection: String, indexedAt: Date, actorDID: String) {
                self.reference = reference
                self.collection = collection
                self.indexedAt = indexedAt
                self.actorDID = actorDID
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.reference = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .reference)
                self.collection = try container.decode(String.self, forKey: .collection)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
                self.actorDID = try container.decode(String.self, forKey: .actorDID)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.reference, forKey: .reference)
                try container.encode(self.collection, forKey: .collection)
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
                try container.encode(self.actorDID, forKey: .actorDID)
            }

            enum CodingKeys: String, CodingKey {
                case reference = "ref"
                case collection
                case indexedAt
                case actorDID = "actor"
            }
        }

        /// The hydrated content an activity targets.
        ///
        /// - Note: According to the AT Protocol specifications: "The hydrated content an activity
        /// targets. For activities that create content, such as publishing an article, the subject
        /// is the created record itself."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimelineV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimelineV2.json
        public struct ActivitySubject: Sendable, Codable {

            /// A strong reference to the record backing the view.
            ///
            /// - Note: According to the AT Protocol specifications: "The record backing the view.
            /// Ex: the site.standard.document of an article."
            public let reference: ComAtprotoLexicon.Repository.StrongReference

            /// The view of the subject.
            public let view: ViewUnion

            /// A strong reference to the Bluesky post associated with the subject. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The Bluesky post associated with
            /// the subject, as declared by its author. The referenced post may not be available."
            public let blueskyPostReference: ComAtprotoLexicon.Repository.StrongReference?

            /// The hydrated Bluesky post associated with the subject. Optional.
            ///
            /// - Note: According to the AT Protocol specifications: "The hydrated Bluesky post
            /// associated with the subject. Omitted when the post is unavailable to the viewer. May
            /// reflect a newer version of the post than the CID in bskyPostRef."
            public let blueskyPostView: AppBskyLexicon.Feed.PostViewDefinition?

            enum CodingKeys: String, CodingKey {
                case reference = "ref"
                case view
                case blueskyPostReference = "bskyPostRef"
                case blueskyPostView = "bskyPostView"
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

                /// The view of a livestream.
                case viewLivestream(AppBskyLexicon.Embed.ExternalDefinition.ViewLivestream)

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
        /// collection close together in time, such as several articles published by the same author.
        /// Activities that create content with relatedActivity are never grouped. Positioned in the
        /// feed at its newest activity."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimelineV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimelineV2.json
        public struct ActivityActorGroup: Sendable, Codable {

            /// The collection of the group's activities.
            public let collection: String

            /// The date and time the group's newest activity was indexed.
            ///
            /// - Note: According to the AT Protocol specifications: "When the group's newest activity
            /// was indexed."
            public let indexedAt: Date

            /// The decentralized identifier (DID) of the actor.
            public let actorDID: String

            /// An array of hydrated subjects of the group's activities.
            ///
            /// - Note: According to the AT Protocol specifications: "Hydrated subjects of the group's
            /// activities, newest first. Currently only the newest subject is included; clients can
            /// hydrate the rest from the subject URIs in activities."
            public let subjects: [AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubject]

            /// An array of all activities in the group.
            ///
            /// - Note: According to the AT Protocol specifications: "All activities in the group,
            /// newest first."
            public let activities: [AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityActorGroupItem]

            public init(collection: String, indexedAt: Date, actorDID: String, subjects: [AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubject],
                        activities: [AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityActorGroupItem]) {
                self.collection = collection
                self.indexedAt = indexedAt
                self.actorDID = actorDID
                self.subjects = subjects
                self.activities = activities
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.collection = try container.decode(String.self, forKey: .collection)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
                self.actorDID = try container.decode(String.self, forKey: .actorDID)
                self.subjects = try container.decode([AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubject].self, forKey: .subjects)
                self.activities = try container.decode([AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityActorGroupItem].self, forKey: .activities)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.collection, forKey: .collection)
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
                try container.encode(self.actorDID, forKey: .actorDID)
                try container.encode(self.subjects, forKey: .subjects)
                try container.encode(self.activities, forKey: .activities)
            }

            enum CodingKeys: String, CodingKey {
                case collection
                case indexedAt
                case actorDID = "actor"
                case subjects
                case activities
            }
        }

        /// An item in a group of activities by one actor.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimelineV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimelineV2.json
        public struct ActivityActorGroupItem: Sendable, Codable {

            /// A strong reference to the activity record.
            public let reference: ComAtprotoLexicon.Repository.StrongReference

            /// The date and time the activity was indexed.
            public let indexedAt: Date

            /// The URI of the content the activity targets.
            ///
            /// - Note: According to the AT Protocol specifications: "The content the activity targets.
            /// Matches ref.uri for activities that create content."
            public let subjectURI: String

            public init(reference: ComAtprotoLexicon.Repository.StrongReference, indexedAt: Date, subjectURI: String) {
                self.reference = reference
                self.indexedAt = indexedAt
                self.subjectURI = subjectURI
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.reference = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .reference)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
                self.subjectURI = try container.decode(String.self, forKey: .subjectURI)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.reference, forKey: .reference)
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
                try container.encode(self.subjectURI, forKey: .subjectURI)
            }

            enum CodingKeys: String, CodingKey {
                case reference = "ref"
                case indexedAt
                case subjectURI = "subject"
            }
        }

        /// A group of activities by at least two actors targeting the same subject.
        ///
        /// - Note: According to the AT Protocol specifications: "Activities by at least two actors in
        /// one collection targeting the same subject, such as several recommendations of an article
        /// published on an earlier page. Positioned in the feed at its newest activity."
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimelineV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimelineV2.json
        public struct ActivitySubjectGroup: Sendable, Codable {

            /// The collection of the group's activities.
            public let collection: String

            /// The date and time the group's newest activity was indexed.
            ///
            /// - Note: According to the AT Protocol specifications: "When the group's newest activity
            /// was indexed."
            public let indexedAt: Date

            /// The shared subject of the group's activities.
            public let subject: AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubject

            /// An array of all activities in the group.
            ///
            /// - Note: According to the AT Protocol specifications: "All activities in the group,
            /// newest first."
            public let activities: [AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubjectGroupItem]

            public init(collection: String, indexedAt: Date, subject: AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubject,
                        activities: [AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubjectGroupItem]) {
                self.collection = collection
                self.indexedAt = indexedAt
                self.subject = subject
                self.activities = activities
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.collection = try container.decode(String.self, forKey: .collection)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
                self.subject = try container.decode(AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubject.self, forKey: .subject)
                self.activities = try container.decode([AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubjectGroupItem].self, forKey: .activities)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.collection, forKey: .collection)
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
                try container.encode(self.subject, forKey: .subject)
                try container.encode(self.activities, forKey: .activities)
            }

            enum CodingKeys: CodingKey {
                case collection
                case indexedAt
                case subject
                case activities
            }
        }

        /// An item in a group of activities targeting the same subject.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimelineV2`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimelineV2.json
        public struct ActivitySubjectGroupItem: Sendable, Codable {

            /// A strong reference to the activity record.
            public let reference: ComAtprotoLexicon.Repository.StrongReference

            /// The date and time the activity was indexed.
            public let indexedAt: Date

            /// The decentralized identifier (DID) of the actor.
            public let actorDID: String

            public init(reference: ComAtprotoLexicon.Repository.StrongReference, indexedAt: Date, actorDID: String) {
                self.reference = reference
                self.indexedAt = indexedAt
                self.actorDID = actorDID
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.reference = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .reference)
                self.indexedAt = try container.decodeDate(forKey: .indexedAt)
                self.actorDID = try container.decode(String.self, forKey: .actorDID)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.reference, forKey: .reference)
                try container.encodeDate(self.indexedAt, forKey: .indexedAt)
                try container.encode(self.actorDID, forKey: .actorDID)
            }

            enum CodingKeys: String, CodingKey {
                case reference = "ref"
                case indexedAt
                case actorDID = "actor"
            }
        }
    }

    /// An output model for getting the Atmosphere activity timeline (v2).
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Get the requesting account's Atmosphere
    /// activity timeline, pre-grouped for rendering. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getAtmosphereTimelineV2`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/unspecced/getAtmosphereTimelineV2.json
    public struct GetAtmosphereTimelineV2Output: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of activities and activity groups.
        ///
        /// - Note: According to the AT Protocol specifications: "Activities and activity groups,
        /// sorted newest first by indexedAt. Groups and relatedActivity only contain activities from
        /// the same page of results. Activities by actors unavailable to the viewer are omitted
        /// before grouping. Clients should ignore entry types they do not recognize."
        public let feed: [FeedUnion]

        /// An array of reusable views referenced by feed entries.
        ///
        /// - Note: According to the AT Protocol specifications: "Reusable views referenced by feed
        /// entries. Views shared across entries appear once to avoid duplication. Always includes
        /// the profile of the actor of every activityItem and activityActorGroup, plus the profiles
        /// of at most the newest 3 distinct actors in each activitySubjectGroup and in each
        /// collection of an activityItem's relatedActivity. Ex: for a subject group of 12
        /// recommendations, only the profiles of the 3 newest recommenders are included; clients
        /// can fetch the rest with app.bsky.actor.getProfiles."
        public let relatedViews: [RelatedViewUnion]

        // Unions
        /// An activity or an activity group.
        public enum FeedUnion: ATUnionProtocol {

            /// A single activity item.
            case activityItem(AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityItem)

            /// A group of activities by one actor.
            case activityActorGroup(AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityActorGroup)

            /// A group of activities targeting the same subject.
            case activitySubjectGroup(AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubjectGroup)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "app.bsky.unspecced.getAtmosphereTimelineV2#activityItem":
                        self = .activityItem(try AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityItem(from: decoder))
                    case "app.bsky.unspecced.getAtmosphereTimelineV2#activityActorGroup":
                        self = .activityActorGroup(try AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivityActorGroup(from: decoder))
                    case "app.bsky.unspecced.getAtmosphereTimelineV2#activitySubjectGroup":
                        self = .activitySubjectGroup(try AppBskyLexicon.Unspecced.GetAtmosphereTimelineV2.ActivitySubjectGroup(from: decoder))
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

        /// A reusable view referenced by feed entries.
        public enum RelatedViewUnion: ATUnionProtocol {

            /// A basic profile view of a user account.
            case profileViewBasic(AppBskyLexicon.Actor.ProfileViewBasicDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decodeIfPresent(String.self, forKey: .type)

                switch type {
                    case "app.bsky.actor.defs#profileViewBasic":
                        self = .profileViewBasic(try AppBskyLexicon.Actor.ProfileViewBasicDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type ?? "unknown", dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .profileViewBasic(let value):
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
