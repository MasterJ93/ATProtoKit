//
//  ATUnion.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

/// An object that lists all of the union types for each of the lexicons.
public struct ATUnion {

    /// A reference containing the list of preferences.
    public enum ActorPreferenceUnion: Codable {

        /// The "Adult Content" preference.
        case adultContent(AppBskyLexicon.Actor.AdultContentPreferencesDefinition)

        /// The "Content Label" preference.
        case contentLabel(AppBskyLexicon.Actor.ContentLabelPreferencesDefinition)

        /// Version 2 of the "Saved Feeds" preference.
        case savedFeedsVersion2(AppBskyLexicon.Actor.SavedFeedPreferencesVersion2Definition)

        /// The "Saved Feeds" preference.
        case savedFeeds(AppBskyLexicon.Actor.SavedFeedsPreferencesDefinition)

        /// The "Personal Details" preference.
        case personalDetails(AppBskyLexicon.Actor.PersonalDetailsPreferencesDefinition)

        /// The "Feed View" preference.
        case feedView(AppBskyLexicon.Actor.FeedViewPreferencesDefinition)

        /// The "Thread View" preference.
        case threadView(AppBskyLexicon.Actor.ThreadViewPreferencesDefinition)

        /// The "Interest View" preference.
        case interestViewPreferences(AppBskyLexicon.Actor.InterestViewPreferencesDefinition)

        /// The "Muted Words" preference.
        case mutedWordsPreferences(AppBskyLexicon.Actor.MutedWordsPreferencesDefinition)

        /// The "Hidden Posts" preference.
        case hiddenPostsPreferences(AppBskyLexicon.Actor.HiddenPostsPreferencesDefinition)

        /// The "Bluesky App State" preference.
        ///
        /// - Important: this should never be used, as it's supposed to be for the official Bluesky iOS client.
        case bskyAppStatePreferences(AppBskyLexicon.Actor.BskyAppStatePreferencesDefinition)

        /// The "Labelers" preference.
        case labelersPreferences(AppBskyLexicon.Actor.LabelersPreferencesDefinition)

        // Implement custom decoding
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Actor.AdultContentPreferencesDefinition.self) {
                self = .adultContent(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.ContentLabelPreferencesDefinition.self) {
                self = .contentLabel(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.SavedFeedPreferencesVersion2Definition.self) {
                self = .savedFeedsVersion2(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.SavedFeedsPreferencesDefinition.self) {
                self = .savedFeeds(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.PersonalDetailsPreferencesDefinition.self) {
                self = .personalDetails(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.FeedViewPreferencesDefinition.self) {
                self = .feedView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.ThreadViewPreferencesDefinition.self) {
                self = .threadView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.InterestViewPreferencesDefinition.self) {
                self = .interestViewPreferences(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.MutedWordsPreferencesDefinition.self) {
                self = .mutedWordsPreferences(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.HiddenPostsPreferencesDefinition.self) {
                self = .hiddenPostsPreferences(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.BskyAppStatePreferencesDefinition.self) {
                self = .bskyAppStatePreferences(value)
            } else if let value = try? container.decode(AppBskyLexicon.Actor.LabelersPreferencesDefinition.self) {
                self = .labelersPreferences(value)
            } else {
                throw DecodingError.typeMismatch(
                    ActorPreferenceUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ActorPreference type"))
            }
        }

        // Implement custom encoding
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .adultContent(let adultContent):
                    try container.encode(adultContent)
                case .contentLabel(let contentLabel):
                    try container.encode(contentLabel)
                case .savedFeedsVersion2(let savedFeedsVersion2):
                    try container.encode(savedFeedsVersion2)
                case .savedFeeds(let savedFeeds):
                    try container.encode(savedFeeds)
                case .personalDetails(let personalDetails):
                    try container.encode(personalDetails)
                case .feedView(let feedView):
                    try container.encode(feedView)
                case .threadView(let threadView):
                    try container.encode(threadView)
                case .interestViewPreferences(let interestViewPreferences):
                    try container.encode(interestViewPreferences)
                case .mutedWordsPreferences(let mutedWordsPreferences):
                    try container.encode(mutedWordsPreferences)
                case .hiddenPostsPreferences(let hiddenPostsPreferences):
                    try container.encode(hiddenPostsPreferences)
                case .bskyAppStatePreferences(let bskyAppStatePreferences):
                    try container.encode(bskyAppStatePreferences)
                case .labelersPreferences(let labelersPreferences):
                    try container.encode(labelersPreferences)
            }
        }
    }

    /// A reference containing the list of the status of a record.
    public enum RecordViewUnion: Codable {

        /// A normal record type.
        case viewRecord(AppBskyLexicon.Embed.RecordDefinition.ViewRecord)

        /// A record that may not have been found.
        case viewNotFound(AppBskyLexicon.Embed.RecordDefinition.ViewNotFound)

        /// A record that may have been blocked.
        case viewBlocked(AppBskyLexicon.Embed.RecordDefinition.ViewBlocked)

        /// A record that may have been detached.
        case viewDetached(AppBskyLexicon.Embed.RecordDefinition.ViewDetached)

        /// A generator view.
        case generatorView(AppBskyLexicon.Feed.GeneratorViewDefinition)

        /// A list view.
        case listView(AppBskyLexicon.Graph.ListViewDefinition)

        /// A labeler view.
        case labelerView(AppBskyLexicon.Labeler.LabelerViewDefinition)

        /// A starter pack view.
        case starterPackViewBasic(AppBskyLexicon.Graph.StarterPackViewBasicDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.ViewRecord.self) {
                self = .viewRecord(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.ViewNotFound.self) {
                self = .viewNotFound(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.ViewBlocked.self) {
                self = .viewBlocked(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.ViewDetached.self) {
                self = .viewDetached(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.GeneratorViewDefinition.self) {
                self = .generatorView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Graph.ListViewDefinition.self) {
                self = .listView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Labeler.LabelerViewDefinition.self) {
                self = .labelerView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Graph.StarterPackViewBasicDefinition.self) {
                self = .starterPackViewBasic(value)
            } else {
                throw DecodingError.typeMismatch(
                    RecordViewUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown RecordViewUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .viewRecord(let viewRecord):
                    try container.encode(viewRecord)
                case .viewNotFound(let viewNotFound):
                    try container.encode(viewNotFound)
                case .viewBlocked(let viewBlocked):
                    try container.encode(viewBlocked)
                case .viewDetached(let viewDetached):
                    try container.encode(viewDetached)
                case .generatorView(let generatorView):
                    try container.encode(generatorView)
                case .listView(let listView):
                    try container.encode(listView)
                case .labelerView(let labelerView):
                    try container.encode(labelerView)
                case .starterPackViewBasic(let starterPackViewBasic):
                    try container.encode(starterPackViewBasic)
            }
        }
    }

    /// A reference containing the list of the types of embeds.
    public enum EmbedViewUnion: Codable {

        /// The view of an external embed.
        case embedExternalView(AppBskyLexicon.Embed.ExternalDefinition.View)

        /// The view of an image embed.
        case embedImagesView(AppBskyLexicon.Embed.ImagesDefinition.View)

        /// The view of a record embed.
        case embedRecordView(AppBskyLexicon.Embed.RecordDefinition.View)

        /// The view of a record embed alongside an embed of some compatible media.
        case embedRecordWithMediaView(AppBskyLexicon.Embed.RecordWithMediaDefinition.View)

        /// The view of a video embed.
        case embedVideoView(AppBskyLexicon.Embed.VideoDefinition.View)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.ExternalDefinition.View.self) {
                self = .embedExternalView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.ImagesDefinition.View.self) {
                self = .embedImagesView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.View.self) {
                self = .embedRecordView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.RecordWithMediaDefinition.View.self) {
                self = .embedRecordWithMediaView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.VideoDefinition.View.self) {
                self = .embedVideoView(value)
            } else {
                throw DecodingError.typeMismatch(
                    EmbedViewUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown EmbedViewUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .embedExternalView(let embedExternalView):
                    try container.encode(embedExternalView)
                case .embedImagesView(let embedImagesView):
                    try container.encode(embedImagesView)
                case .embedRecordView(let embedRecordView):
                    try container.encode(embedRecordView)
                case .embedRecordWithMediaView(let embedRecordWithMediaView):
                    try container.encode(embedRecordWithMediaView)
                case .embedVideoView(let value):
                    try container.encode(value)
            }
        }
    }

    /// A reference containing the list of the types of compatible media.
    public enum RecordWithMediaUnion: Codable {

        /// An image that will be embedded.
        case embedImages(AppBskyLexicon.Embed.ImagesDefinition)

        /// An external link that will be embedded.
        case embedExternal(AppBskyLexicon.Embed.ExternalDefinition)

        /// A video that will be embedded.
        case embedVideo(AppBskyLexicon.Embed.VideoDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.ImagesDefinition.self) {
                self = .embedImages(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.ExternalDefinition.self) {
                self = .embedExternal(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.VideoDefinition.self) {
                self = .embedVideo(value)
            } else {
                throw DecodingError.typeMismatch(
                    RecordWithMediaUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown RecordWithMediaUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .embedImages(let media):
                    try container.encode(media)
                case .embedExternal(let media):
                    try container.encode(media)
                case .embedVideo(let value):
                    try container.encode(value)
            }
        }
    }

    /// A reference containing the list of the types of compatible media that can be viewed.
    public enum MediaViewUnion: Codable {

        /// An image that's been embedded.
        case embedImagesView(AppBskyLexicon.Embed.ImagesDefinition.View)

        /// A video tht's been embedded.
        case embedVideoView(AppBskyLexicon.Embed.VideoDefinition.View)

        /// An external link that's been embedded.
        case embedExternalView(AppBskyLexicon.Embed.ExternalDefinition.View)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.ImagesDefinition.View.self) {
                self = .embedImagesView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.VideoDefinition.View.self) {
                self = .embedVideoView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.ExternalDefinition.View.self) {
                self = .embedExternalView(value)
            } else {
                throw DecodingError.typeMismatch(
                    MediaViewUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MediaViewUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .embedImagesView(let mediaView):
                    try container.encode(mediaView)
                case .embedVideoView(let mediaView):
                    try container.encode(mediaView)
                case .embedExternalView(let mediaView):
                    try container.encode(mediaView)
            }
        }
    }

    /// A reference containing the list of reposts.
    public enum ReasonRepostUnion: Codable {

        /// A very stripped down version of a repost.
        case reasonRepost(AppBskyLexicon.Feed.ReasonRepostDefinition)

        /// A marker for pinned posts.
        case reasonPinned(AppBskyLexicon.Feed.ReasonPinnedDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.ReasonRepostDefinition.self) {
                self = .reasonRepost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.ReasonPinnedDefinition.self) {
                self = .reasonPinned(value)
            } else {
                throw DecodingError.typeMismatch(
                    ReasonRepostUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ReasonRepostUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .reasonRepost(let reasonRepost):
                    try container.encode(reasonRepost)
                case .reasonPinned(let reasonPinned):
                    try container.encode(reasonPinned)
            }
        }
    }

    /// A reference containing the list of the states of a post.
    public enum ReplyReferenceRootUnion: Codable {

        /// The view of a post.
        case postView(AppBskyLexicon.Feed.PostViewDefinition)

        /// The view of a post that may not have been found.
        case notFoundPost(AppBskyLexicon.Feed.NotFoundPostDefinition)

        /// The view of a post that's been blocked by the post author.
        case blockedPost(AppBskyLexicon.Feed.BlockedPostDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.PostViewDefinition.self) {
                self = .postView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.NotFoundPostDefinition.self) {
                self = .notFoundPost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.BlockedPostDefinition.self) {
                self = .blockedPost(value)
            } else {
                throw DecodingError.typeMismatch(
                    ReplyReferenceRootUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ReplyReferenceRootUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .postView(let postView):
                    try container.encode(postView)
                case .notFoundPost(let notFoundPost):
                    try container.encode(notFoundPost)
                case .blockedPost(let blockedPost):
                    try container.encode(blockedPost)
            }
        }
    }

    /// A reference containing the list of the states of a post.
    public enum ReplyReferenceParentUnion: Codable {

        /// The view of a post.
        case postView(AppBskyLexicon.Feed.PostViewDefinition)

        /// The view of a post that may not have been found.
        case notFoundPost(AppBskyLexicon.Feed.NotFoundPostDefinition)

        /// The view of a post that's been blocked by the post author.
        case blockedPost(AppBskyLexicon.Feed.BlockedPostDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.PostViewDefinition.self) {
                self = .postView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.NotFoundPostDefinition.self) {
                self = .notFoundPost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.BlockedPostDefinition.self) {
                self = .blockedPost(value)
            } else {
                throw DecodingError.typeMismatch(
                    ReplyReferenceParentUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ReplyReferenceParentUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .postView(let postView):
                    try container.encode(postView)
                case .notFoundPost(let notFoundPost):
                    try container.encode(notFoundPost)
                case .blockedPost(let blockedPost):
                    try container.encode(blockedPost)
            }
        }
    }

    /// A reference containing the list of the states of a thread post parent.
    public indirect enum ThreadViewPostParentUnion: Codable {

        /// The view of a post thread.
        case threadViewPost(AppBskyLexicon.Feed.ThreadViewPostDefinition)

        /// The view of a post that may not have been found.
        case notFoundPost(AppBskyLexicon.Feed.NotFoundPostDefinition)

        /// The view of a post that's been blocked by the post author.
        case blockedPost(AppBskyLexicon.Feed.BlockedPostDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.ThreadViewPostDefinition.self) {
                self = .threadViewPost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.NotFoundPostDefinition.self) {
                self = .notFoundPost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.BlockedPostDefinition.self) {
                self = .blockedPost(value)
            } else {
                throw DecodingError.typeMismatch(
                    ThreadViewPostParentUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ThreadViewPostParentUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .threadViewPost(let threadViewPost):
                    try container.encode(threadViewPost)
                case .notFoundPost(let notFoundPost):
                    try container.encode(notFoundPost)
                case .blockedPost(let blockedPost):
                    try container.encode(blockedPost)
            }
        }
    }

    /// A reference containing the list of the states of a thread post reply.
    public indirect enum ThreadViewPostRepliesUnion: Codable {

        /// The view of a post thread.
        case threadViewPost(AppBskyLexicon.Feed.ThreadViewPostDefinition)

        /// The view of a post that may not have been found.
        case notFoundPost(AppBskyLexicon.Feed.NotFoundPostDefinition)

        /// The view of a post that's been blocked by the post author.
        case blockedPost(AppBskyLexicon.Feed.BlockedPostDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.ThreadViewPostDefinition.self) {
                self = .threadViewPost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.NotFoundPostDefinition.self) {
                self = .notFoundPost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.BlockedPostDefinition.self) {
                self = .blockedPost(value)
            } else {
                throw DecodingError.typeMismatch(
                    ThreadViewPostRepliesUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ThreadViewPostRepliesUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .threadViewPost(let threadViewPost):
                    try container.encode(threadViewPost)
                case .notFoundPost(let notFoundPost):
                    try container.encode(notFoundPost)
                case .blockedPost(let blockedPost):
                    try container.encode(blockedPost)
            }
        }
    }

    /// A reference containing the list of reposts.
    public enum SkeletonReasonRepostUnion: Codable {

        /// A very stripped down version of a repost.
        case skeletonReasonRepost(AppBskyLexicon.Feed.SkeletonReasonRepostDefinition)

        /// A pin in a feed generator.
        case skeletonReasonPin(AppBskyLexicon.Feed.SkeletonReasonPin)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.SkeletonReasonRepostDefinition.self) {
                self = .skeletonReasonRepost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.SkeletonReasonPin.self) {
                self = .skeletonReasonPin(value)
            } else {
                throw DecodingError.typeMismatch(
                    SkeletonReasonRepostUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown SkeletonReasonRepostUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .skeletonReasonRepost(let skeletonReasonRepost):
                    try container.encode(skeletonReasonRepost)
                case .skeletonReasonPin(let value):
                    try container.encode(value)
            }
        }
    }

    /// A reference containing the list of user-defined labels for feed generators.
    public enum GeneratorLabelsUnion: Codable {

        /// An array of user-defined labels.
        case selfLabels(ComAtprotoLexicon.Label.SelfLabelsDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Label.SelfLabelsDefinition.self) {
                self = .selfLabels(value)
            } else {
                throw DecodingError.typeMismatch(
                    GeneratorLabelsUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown GeneratorLabelsUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .selfLabels(let selfLabelsValue):
                    try container.encode(selfLabelsValue)
            }
        }

        enum CodingKeys: String, CodingKey {
            case selfLabels
        }
    }

    /// A reference containing the list of the states of a thread post reply.
    public enum GetPostThreadOutputThreadUnion: Codable {

        /// The view of a post thread.
        case threadViewPost(AppBskyLexicon.Feed.ThreadViewPostDefinition)

        /// The view of a post that may not have been found.
        case notFoundPost(AppBskyLexicon.Feed.NotFoundPostDefinition)

        /// The view of a post that's been blocked by the post author.
        case blockedPost(AppBskyLexicon.Feed.BlockedPostDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.ThreadViewPostDefinition.self) {
                self = .threadViewPost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.NotFoundPostDefinition.self) {
                self = .notFoundPost(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.BlockedPostDefinition.self) {
                self = .blockedPost(value)
            } else {
                throw DecodingError.typeMismatch(
                    GetPostThreadOutputThreadUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown GetPostThreadOutputThreadUnion type"))
            }
        }
    }

    /// A reference containing the list of types of embeds.
    public enum PostEmbedUnion: Codable {

        /// An image embed.
        case images(AppBskyLexicon.Embed.ImagesDefinition)

        /// An external embed.
        case external(AppBskyLexicon.Embed.ExternalDefinition)

        /// A record embed.
        case record(AppBskyLexicon.Embed.RecordDefinition)

        /// A embed with both a record and some compatible media.
        case recordWithMedia(AppBskyLexicon.Embed.RecordWithMediaDefinition)

        /// A video embed.
        case video(AppBskyLexicon.Embed.VideoDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let imagesValue = try? container.decode(AppBskyLexicon.Embed.ImagesDefinition.self) {
                self = .images(imagesValue)
            } else if let externalValue = try? container.decode(AppBskyLexicon.Embed.ExternalDefinition.self) {
                self = .external(externalValue)
            } else if let recordValue = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.self) {
                self = .record(recordValue)
            } else if let recordWithMediaValue = try? container.decode(AppBskyLexicon.Embed.RecordWithMediaDefinition.self) {
                self = .recordWithMedia(recordWithMediaValue)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.VideoDefinition.self) {
                self = .video(value)
            } else {
                throw DecodingError.typeMismatch(
                    PostEmbedUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown PostEmbedUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .images(let imagesValue):
                    try container.encode(imagesValue)
                case .external(let externalValue):
                    try container.encode(externalValue)
                case .record(let recordValue):
                    try container.encode(recordValue)
                case .recordWithMedia(let recordWithMediaValue):
                    try container.encode(recordWithMediaValue)
                case .video(let value):
                    try container.encode(value)
            }
        }
    }

    /// A reference containing the list of user-defined labels.
    public enum PostSelfLabelsUnion: Codable {

        /// An array of user-defined labels.
        case selfLabels(ComAtprotoLexicon.Label.SelfLabelsDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Label.SelfLabelsDefinition.self) {
                self = .selfLabels(value)
            } else {
                throw DecodingError.typeMismatch(
                    PostSelfLabelsUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown PostSelfLabelsUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .selfLabels(let selfLabelsValue):
                    try container.encode(selfLabelsValue)
            }
        }
    }

    public enum EmbeddingRulesUnion: Codable {

        case disabledRule(AppBskyLexicon.Feed.PostgateRecord)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.PostgateRecord.self) {
                self = .disabledRule(value)
            } else {
                throw DecodingError.typeMismatch(
                    EmbeddingRulesUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown EmbeddingRulesUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .disabledRule(let disabledRule):
                    try container.encode(disabledRule)
            }
        }
    }

    /// A reference containing the list of thread rules for a post.
    public enum ThreadgateUnion: Codable {

        /// A rule that indicates whether users that the post author mentions can reply to the post.
        case mentionRule(AppBskyLexicon.Feed.ThreadgateRecord.MentionRule)

        /// A rule that indicates whether users that the post author is following can reply to the post.
        case followingRule(AppBskyLexicon.Feed.ThreadgateRecord.FollowingRule)

        /// A rule that indicates whether users that are on a specific list made by the post author can
        /// reply to the post.
        case listRule(AppBskyLexicon.Feed.ThreadgateRecord.ListRule)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.ThreadgateRecord.MentionRule.self) {
                self = .mentionRule(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.ThreadgateRecord.FollowingRule.self) {
                self = .followingRule(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.ThreadgateRecord.ListRule.self) {
                self = .listRule(value)
            } else {
                throw DecodingError.typeMismatch(
                    ThreadgateUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ThreadgateUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .mentionRule(let embedView):
                    try container.encode(embedView)
                case .followingRule(let embedView):
                    try container.encode(embedView)
                case .listRule(let embedView):
                    try container.encode(embedView)
            }
        }
    }

    /// A reference containing the list of relationships of multiple user accounts.
    public enum GetRelationshipsOutputRelationshipUnion: Codable {

        /// The relationship between two user accounts.
        case relationship(AppBskyLexicon.Graph.RelationshipDefinition)

        /// Indicates the user account is not found.
        case notFoundActor(AppBskyLexicon.Graph.NotFoundActorDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Graph.RelationshipDefinition.self) {
                self = .relationship(value)
            } else if let value = try? container.decode(AppBskyLexicon.Graph.NotFoundActorDefinition.self) {
                self = .notFoundActor(value)
            } else {
                throw DecodingError.typeMismatch(
                    GetRelationshipsOutputRelationshipUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown GetRelationshipsOutputRelationshipUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .relationship(let relationship):
                    try container.encode(relationship)
                case .notFoundActor(let notFoundActor):
                    try container.encode(notFoundActor)
            }
        }
    }

    /// A reference containing the list of labeler views.
    public enum GetServicesOutputViewsUnion: Codable {

        /// A labeler view.
        case labelerView(AppBskyLexicon.Labeler.LabelerViewDefinition)

        /// A detailed view of a labeler.
        case labelerViewDetailed(AppBskyLexicon.Labeler.LabelerViewDetailedDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Labeler.LabelerViewDefinition.self) {
                self = .labelerView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Labeler.LabelerViewDetailedDefinition.self) {
                self = .labelerViewDetailed(value)
            } else {
                throw DecodingError.typeMismatch(
                    GetServicesOutputViewsUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown GetServicesOutputViewsUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .labelerView(let labelerView):
                    try container.encode(labelerView)
                case .labelerViewDetailed(let labelerViewDetailed):
                    try container.encode(labelerViewDetailed)
            }
        }
    }

    /// A reference containing the list of feature types.
    public enum FacetFeatureUnion: Codable {

        /// The Mention feature.
        case mention(AppBskyLexicon.RichText.Facet.Mention)

        /// The Link feature.
        case link(AppBskyLexicon.RichText.Facet.Link)

        /// The Tag feature.
        case tag(AppBskyLexicon.RichText.Facet.Tag)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.RichText.Facet.Mention.self) {
                self = .mention(value)
            } else if let value = try? container.decode(AppBskyLexicon.RichText.Facet.Link.self) {
                self = .link(value)
            } else if let value = try? container.decode(AppBskyLexicon.RichText.Facet.Tag.self) {
                self = .tag(value)
            } else {
                throw DecodingError.typeMismatch(
                    FacetFeatureUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown FacetFeatureUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .mention(let mention):
                    try container.encode(mention)
                case .link(let link):
                    try container.encode(link)
                case .tag(let tag):
                    try container.encode(tag)
            }
        }
    }

    /// A reference containing the list of user-defined labels for feed generators.
    public enum ListLabelsUnion: Codable {

        /// An array of user-defined labels.
        case selfLabels(ComAtprotoLexicon.Label.SelfLabelsDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Label.SelfLabelsDefinition.self) {
                self = .selfLabels(value)
            } else {
                throw DecodingError.typeMismatch(
                    ListLabelsUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ListLabelsUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .selfLabels(let selfLabelsValue):
                    try container.encode(selfLabelsValue)
            }
        }
    }

    /// A reference containing the list of message embeds.
    public enum MessageInputEmbedUnion: Codable {

        /// A record within the embed.
        case record(AppBskyLexicon.Embed.RecordDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.self) {
                self = .record(value)
            } else {
                throw DecodingError.typeMismatch(
                    MessageInputEmbedUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MessageInputEmbedUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .record(let record):
                    try container.encode(record)
            }
        }
    }

    /// A reference containing the list of message embeds.
    public enum MessageViewEmbedUnion: Codable {

        /// A record within the embed.
        case record(AppBskyLexicon.Embed.RecordDefinition.View)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.View.self) {
                self = .record(value)
            } else {
                throw DecodingError.typeMismatch(
                    MessageViewEmbedUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MessageViewEmbedUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .record(let record):
                    try container.encode(record)
            }
        }
    }

    /// A reference containing the list of messages.
    public enum ConversationViewLastMessageUnion: Codable {

        /// A message view.
        case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

        /// A deleted message view.
        case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageViewDefinition.self) {
                self = .messageView(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self) {
                self = .deletedMessageView(value)
            } else {
                throw DecodingError.typeMismatch(
                    ConversationViewLastMessageUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ConversationViewLastMessageUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .messageView(let messageView):
                    try container.encode(messageView)
                case .deletedMessageView(let deletedMessageView):
                    try container.encode(deletedMessageView)
            }
        }
    }

    /// A reference containing the list of messages.
    public enum LogCreateMessageUnion: Codable {

        /// A message view.
        case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

        /// A deleted message view.
        case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageViewDefinition.self) {
                self = .messageView(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self) {
                self = .deletedMessageView(value)
            } else {
                throw DecodingError.typeMismatch(
                    LogCreateMessageUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown LogCreateMessageUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .messageView(let messageView):
                    try container.encode(messageView)
                case .deletedMessageView(let deletedMessageView):
                    try container.encode(deletedMessageView)
            }
        }
    }

    /// A reference containing the list of messages.
    public enum LogDeleteMessageUnion: Codable {

        /// A message view.
        case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

        /// A deleted message view.
        case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageViewDefinition.self) {
                self = .messageView(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self) {
                self = .deletedMessageView(value)
            } else {
                throw DecodingError.typeMismatch(
                    LogDeleteMessageUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown LogDeleteMessageUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .messageView(let messageView):
                    try container.encode(messageView)
                case .deletedMessageView(let deletedMessageView):
                    try container.encode(deletedMessageView)
            }
        }
    }

    /// A reference containing the list of message logs.
    public enum MessageLogsUnion: Codable {

        /// A log entry for beginning the coversation.
        case logBeginConversation(ChatBskyLexicon.Conversation.LogBeginConversationDefinition)

        /// A log entry for leaving the conversation.
        case logLeaveConversation(ChatBskyLexicon.Conversation.LogLeaveConversationDefinition)

        /// A log entry for creating a message.
        case logCreateMessage(ChatBskyLexicon.Conversation.LogCreateMessageDefinition)

        /// A log entry for deleting a message.
        case logDeleteMessage(ChatBskyLexicon.Conversation.LogDeleteMessageDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.LogBeginConversationDefinition.self) {
                self = .logBeginConversation(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogLeaveConversationDefinition.self) {
                self = .logLeaveConversation(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogCreateMessageDefinition.self) {
                self = .logCreateMessage(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogDeleteMessageDefinition.self) {
                self = .logDeleteMessage(value)
            } else {
                throw DecodingError.typeMismatch(
                    MessageLogsUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MessageLogsUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .logBeginConversation(let logBeginConversation):
                    try container.encode(logBeginConversation)
                case .logLeaveConversation(let logLeaveConversation):
                    try container.encode(logLeaveConversation)
                case .logCreateMessage(let logCreateMessage):
                    try container.encode(logCreateMessage)
                case .logDeleteMessage(let logDeleteMessage):
                    try container.encode(logDeleteMessage)
            }
        }
    }

    /// A reference containing the list of messages.
    public enum GetMessagesOutputMessagesUnion: Codable {

        /// A message view.
        case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

        /// A deleted message view.
        case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageViewDefinition.self) {
                self = .messageView(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self) {
                self = .deletedMessageView(value)
            } else {
                throw DecodingError.typeMismatch(
                    GetMessagesOutputMessagesUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown GetMessagesOutputMessagesUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .messageView(let messageView):
                    try container.encode(messageView)
                case .deletedMessageView(let deletedMessageView):
                    try container.encode(deletedMessageView)
            }
        }
    }

    /// A reference containing the list of messages.
    public enum GetMessageContextOutputMessagesUnion: Codable {

        /// A message view.
        case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

        /// A deleted message view.
        case deletedMessageView(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageViewDefinition.self) {
                self = .messageView(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeletedMessageViewDefinition.self) {
                self = .deletedMessageView(value)
            } else {
                throw DecodingError.typeMismatch(
                    ConversationViewLastMessageUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ConversationViewLastMessageUnion type"))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .messageView(let messageView):
                    try container.encode(messageView)
                case .deletedMessageView(let deletedMessageView):
                    try container.encode(deletedMessageView)
            }
        }
    }

    /// A reference containing the list of repository references.
    public enum AdminGetSubjectStatusUnion: Codable {

        /// A repository reference.
        case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

        /// A strong reference.
        case strongReference(ComAtprotoLexicon.Repository.StrongReference)

        /// A repository blob reference.
        case repositoryBlobReference(ComAtprotoLexicon.Admin.RepositoryBlobReferenceDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition.self) {
                self = .repositoryReference(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.StrongReference.self) {
                self = .strongReference(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryBlobReferenceDefinition.self) {
                self = .repositoryBlobReference(value)
            } else {
                throw DecodingError.typeMismatch(
                    AdminGetSubjectStatusUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown AdminGetSubjectStatusUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .repositoryReference(let repositoryReference):
                    try container.encode(repositoryReference)
                case .strongReference(let strongReference):
                    try container.encode(strongReference)
                case .repositoryBlobReference(let repoBlobReference):
                    try container.encode(repoBlobReference)
            }
        }
    }

    /// A reference containing the list of repository references.
    public enum AdminUpdateSubjectStatusUnion: Codable {

        /// A repository reference.
        case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

        /// A strong reference.
        case strongReference(ComAtprotoLexicon.Repository.StrongReference)

        /// A repository blob reference.
        case repositoryBlobReference(ComAtprotoLexicon.Admin.RepositoryBlobReferenceDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition.self) {
                self = .repositoryReference(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.StrongReference.self) {
                self = .strongReference(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryBlobReferenceDefinition.self) {
                self = .repositoryBlobReference(value)
            } else {
                throw DecodingError.typeMismatch(
                    AdminUpdateSubjectStatusUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Uknown AdminUpdateSubjectStatusUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .repositoryReference(let repositoryReference):
                    try container.encode(repositoryReference)
                case .strongReference(let strongReference):
                    try container.encode(strongReference)
                case .repositoryBlobReference(let repoBlobReference):
                    try container.encode(repoBlobReference)
            }
        }
    }

    /// A reference containing the list of repository references.
    public enum CreateReportSubjectUnion: Codable {

        /// A repository reference.
        case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

        /// A strong reference.
        case strongReference(ComAtprotoLexicon.Repository.StrongReference)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition.self) {
                self = .repositoryReference(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.StrongReference.self) {
                self = .strongReference(value)
            } else {
                throw DecodingError.typeMismatch(
                    CreateReportSubjectUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown CreateReportSubjectUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .repositoryReference(let repositoryReference):
                    try container.encode(repositoryReference)
                case .strongReference(let strongReference):
                    try container.encode(strongReference)
            }
        }
    }

    /// A reference containing the list of write operations.
    public enum ApplyWritesUnion: Codable {

        /// A "Create" write operation.
        case create(ComAtprotoLexicon.Repository.ApplyWrites.Create)

        /// An "Update" write operation.
        case update(ComAtprotoLexicon.Repository.ApplyWrites.Update)

        /// A "Delete" write operation.
        case delete(ComAtprotoLexicon.Repository.ApplyWrites.Delete)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Repository.ApplyWrites.Create.self) {
                self = .create(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.ApplyWrites.Update.self) {
                self = .update(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.ApplyWrites.Delete.self) {
                self = .delete(value)
            } else {
                throw DecodingError.typeMismatch(
                    ApplyWritesUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ApplyWritesUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .create(let embedView):
                    try container.encode(embedView)
                case .update(let embedView):
                    try container.encode(embedView)
                case .delete(let embedView):
                    try container.encode(embedView)
            }
        }
    }

    /// A reference containing the list of event views.
    public enum ModerationEventViewUnion: Codable {

        /// A takedown event.
        case moderationEventTakedown(ToolsOzoneLexicon.Moderation.EventTakedownDefinition)

        /// A reverse takedown event.
        case moderationEventReverseTakedown(ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition)

        /// A comment event.
        case moderationEventComment(ToolsOzoneLexicon.Moderation.EventCommentDefinition)

        /// A report event.
        case moderationEventReport(ToolsOzoneLexicon.Moderation.EventReportDefinition)

        /// A label event.
        case moderationEventLabel(ToolsOzoneLexicon.Moderation.EventLabelDefinition)

        /// An acknowledgement event.
        case moderationEventAcknowledge(ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition)

        /// An escalation event.
        case moderationEventEscalate(ToolsOzoneLexicon.Moderation.EventEscalateDefinition)

        /// A mute event.
        case moderationEventMute(ToolsOzoneLexicon.Moderation.EventMuteDefinition)

        /// An unmute event.
        case moderationEventUnmute(ToolsOzoneLexicon.Moderation.EventUnmuteDefinition)

        /// A mute reporter event.
        case moderationEventMuteReporter(ToolsOzoneLexicon.Moderation.EventMuteReporterDefinition)

        /// An unmute reporter event.
        case moderationEventUnmuteReporter(ToolsOzoneLexicon.Moderation.EventUnmuteReporterDefinition)

        /// An email event.
        case moderationEventEmail(ToolsOzoneLexicon.Moderation.EventEmailDefinition)

        /// A resolve appeal event.
        case moderationEventResolveAppeal(ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition)

        /// A diversion event.
        case moderationEventDivert(ToolsOzoneLexicon.Moderation.EventDivertDefinition)

        /// A tag event.
        case moderationEventTag(ToolsOzoneLexicon.Moderation.EventTagDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventTakedownDefinition.self) {
                self = .moderationEventTakedown(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition.self) {
                self = .moderationEventReverseTakedown(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventCommentDefinition.self) {
                self = .moderationEventComment(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventReportDefinition.self) {
                self = .moderationEventReport(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventLabelDefinition.self) {
                self = .moderationEventLabel(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition.self) {
                self = .moderationEventAcknowledge(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventEscalateDefinition.self) {
                self = .moderationEventEscalate(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventMuteDefinition.self) {
                self = .moderationEventMute(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventUnmuteDefinition.self) {
                self = .moderationEventUnmute(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventMuteReporterDefinition.self) {
                self = .moderationEventMuteReporter(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventUnmuteReporterDefinition.self) {
                self = .moderationEventUnmuteReporter(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventEmailDefinition.self) {
                self = .moderationEventEmail(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition.self) {
                self = .moderationEventResolveAppeal(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventDivertDefinition.self) {
                self = .moderationEventDivert(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventTagDefinition.self) {
                self = .moderationEventTag(value)
            } else {
                throw DecodingError.typeMismatch(
                    ModerationEventViewUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ModerationEventViewUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .moderationEventTakedown(let moderationEventTakedown):
                    try container.encode(moderationEventTakedown)
                case .moderationEventReverseTakedown(let moderationEventReverseTakedown):
                    try container.encode(moderationEventReverseTakedown)
                case .moderationEventComment(let moderationEventComment):
                    try container.encode(moderationEventComment)
                case .moderationEventReport(let moderationEventReport):
                    try container.encode(moderationEventReport)
                case .moderationEventLabel(let moderationEventLabel):
                    try container.encode(moderationEventLabel)
                case .moderationEventAcknowledge(let moderationEventAcknowledge):
                    try container.encode(moderationEventAcknowledge)
                case .moderationEventEscalate(let moderationEventEscalate):
                    try container.encode(moderationEventEscalate)
                case .moderationEventMute(let moderationEventMute):
                    try container.encode(moderationEventMute)
                case .moderationEventUnmute(let moderationEventUnmute):
                    try container.encode(moderationEventUnmute)
                case .moderationEventMuteReporter(let moderationEventMuteReporter):
                    try container.encode(moderationEventMuteReporter)
                case .moderationEventUnmuteReporter(let moderationEventUnmuteReporter):
                    try container.encode(moderationEventUnmuteReporter)
                case .moderationEventEmail(let moderationEventEmail):
                    try container.encode(moderationEventEmail)
                case .moderationEventResolveAppeal(let moderationEventResolveAppeal):
                    try container.encode(moderationEventResolveAppeal)
                case .moderationEventDivert(let moderationEventDivert):
                    try container.encode(moderationEventDivert)
                case .moderationEventTag(let moderationEventTag):
                    try container.encode(moderationEventTag)
            }
        }
    }

    /// A reference containing the list of repository references.
    public enum ModerationEventViewSubjectUnion: Codable {

        /// A repository reference.
        case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

        /// A strong reference.
        case strongReference(ComAtprotoLexicon.Repository.StrongReference)

        /// A message reference for a conversation.
        case messageReference(ChatBskyLexicon.Conversation.MessageReferenceDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition.self) {
                self = .repositoryReference(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.StrongReference.self) {
                self = .strongReference(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageReferenceDefinition.self) {
                self = .messageReference(value)
            } else {
                throw DecodingError.typeMismatch(
                    ModerationEventViewSubjectUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ModerationEventViewSubjectUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .repositoryReference(let repositoryReference):
                    try container.encode(repositoryReference)
                case .strongReference(let strongReference):
                    try container.encode(strongReference)
                case .messageReference(let messageReference):
                    try container.encode(messageReference)
            }
        }
    }

    /// A reference containing the list of moderator events.
    public enum ModerationEventViewDetailUnion: Codable {

        /// A takedown event.
        case moderationEventTakedown(ToolsOzoneLexicon.Moderation.EventTakedownDefinition)

        /// A reverse takedown event.
        case moderationEventReverseTakedown(ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition)

        /// A comment event.
        case moderationEventComment(ToolsOzoneLexicon.Moderation.EventCommentDefinition)

        /// A report event.
        case moderationEventReport(ToolsOzoneLexicon.Moderation.EventReportDefinition)

        /// A label event.
        case moderationEventLabel(ToolsOzoneLexicon.Moderation.EventLabelDefinition)

        /// An acknowledgment event.
        case moderationEventAcknowledge(ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition)

        /// An escalation event.
        case moderationEventEscalate(ToolsOzoneLexicon.Moderation.EventEscalateDefinition)

        /// A mute event.
        case moderationEventMute(ToolsOzoneLexicon.Moderation.EventMuteDefinition)

        /// A resolve appeal event.
        case moderationEventResolveAppeal(ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition)

        /// A tag event.
        case moderationEventTag(ToolsOzoneLexicon.Moderation.EventTagDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventTakedownDefinition.self) {
                self = .moderationEventTakedown(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition.self) {
                self = .moderationEventReverseTakedown(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventCommentDefinition.self) {
                self = .moderationEventComment(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventReportDefinition.self) {
                self = .moderationEventReport(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventLabelDefinition.self) {
                self = .moderationEventLabel(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition.self) {
                self = .moderationEventAcknowledge(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventEscalateDefinition.self) {
                self = .moderationEventEscalate(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventMuteDefinition.self) {
                self = .moderationEventMute(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition.self) {
                self = .moderationEventResolveAppeal(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventTagDefinition.self) {
                self = .moderationEventTag(value)
            } else {
                throw DecodingError.typeMismatch(
                    ModerationEventViewDetailUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ModerationEventViewDetailUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .moderationEventTakedown(let moderationEventTakedown):
                    try container.encode(moderationEventTakedown)
                case .moderationEventReverseTakedown(let moderationEventDetail):
                    try container.encode(moderationEventDetail)
                case .moderationEventComment(let moderationEventComment):
                    try container.encode(moderationEventComment)
                case .moderationEventReport(let moderationEventReport):
                    try container.encode(moderationEventReport)
                case .moderationEventLabel(let moderationEventLabel):
                    try container.encode(moderationEventLabel)
                case .moderationEventAcknowledge(let moderationEventAcknowledge):
                    try container.encode(moderationEventAcknowledge)
                case .moderationEventEscalate(let moderationEventEscalate):
                    try container.encode(moderationEventEscalate)
                case .moderationEventMute(let moderationEventMute):
                    try container.encode(moderationEventMute)
                case .moderationEventResolveAppeal(let moderationEventResolveAppeal):
                    try container.encode(moderationEventResolveAppeal)
                case .moderationEventTag(let moderationEventTag):
                    try container.encode(moderationEventTag)
            }
        }
    }

    /// A reference containing the list of repository references.
    public enum ModerationEventViewDetailSubjectUnion: Codable {

        /// A repository reference.
        case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

        /// A strong reference.
        case strongReference(ComAtprotoLexicon.Repository.StrongReference)

        /// A message reference for a conversation.
        case messageReference(ChatBskyLexicon.Conversation.MessageReferenceDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition.self) {
                self = .repositoryReference(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.StrongReference.self) {
                self = .strongReference(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageReferenceDefinition.self) {
                self = .messageReference(value)
            } else {
                throw DecodingError.typeMismatch(
                    ModerationEventViewDetailSubjectUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ModerationEventViewDetailSubjectUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .repositoryReference(let repositoryReference):
                    try container.encode(repositoryReference)
                case .strongReference(let strongReference):
                    try container.encode(strongReference)
                case .messageReference(let messageReference):
                    try container.encode(messageReference)
            }
        }
    }

    /// A reference containing the list of repository references.
    public enum SubjectStatusViewSubjectUnion: Codable {

        /// A repository reference.
        case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

        /// A strong reference.
        case strongReference(ComAtprotoLexicon.Repository.StrongReference)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition.self) {
                self = .repositoryReference(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.StrongReference.self) {
                self = .strongReference(value)
            } else {
                throw DecodingError.typeMismatch(
                    SubjectStatusViewSubjectUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown SubjectStatusViewSubjectUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .repositoryReference(let repositoryReference):
                    try container.encode(repositoryReference)
                case .strongReference(let strongReference):
                    try container.encode(strongReference)
            }
        }
    }

    /// A reference containing the list of the types of media details.
    public enum BlobViewDetailUnion: Codable {

        /// The details for an image.
        case mediaImageDetails(ToolsOzoneLexicon.Moderation.ImageDetailsDefinition)

        /// The details for a video.
        case mediaVideoDetails(ToolsOzoneLexicon.Moderation.VideoDetailsDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ToolsOzoneLexicon.Moderation.ImageDetailsDefinition.self) {
                self = .mediaImageDetails(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.VideoDetailsDefinition.self) {
                self = .mediaVideoDetails(value)
            } else {
                throw DecodingError.typeMismatch(
                    BlobViewDetailUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown BlobViewDetailUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .mediaImageDetails(let mediaImageDetails):
                    try container.encode(mediaImageDetails)
                case .mediaVideoDetails(let mediaVideoDetails):
                    try container.encode(mediaVideoDetails)
            }
        }
    }

    /// A reference containing the list of event views.
    public enum EmitEventUnion: Codable {

        /// A takedown event.
        case moderationEventTakedown(ToolsOzoneLexicon.Moderation.EventTakedownDefinition)

        /// A reverse takedown event.
        case moderationEventReverseTakedown(ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition)

        /// A comment event.
        case moderationEventComment(ToolsOzoneLexicon.Moderation.EventCommentDefinition)

        /// A report event.
        case moderationEventReport(ToolsOzoneLexicon.Moderation.EventReportDefinition)

        /// A label event.
        case moderationEventLabel(ToolsOzoneLexicon.Moderation.EventLabelDefinition)

        /// An acknowledgement event.
        case moderationEventAcknowledge(ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition)

        /// An escalation event.
        case moderationEventEscalate(ToolsOzoneLexicon.Moderation.EventEscalateDefinition)

        /// A mute event.
        case moderationEventMute(ToolsOzoneLexicon.Moderation.EventMuteDefinition)

        /// An unmute event.
        case moderationEventUnmute(ToolsOzoneLexicon.Moderation.EventUnmuteDefinition)

        /// A mute reporter event.
        case moderationEventMuteReporter(ToolsOzoneLexicon.Moderation.EventMuteReporterDefinition)

        /// An unmute reporter event.
        case moderationEventUnmuteReporter(ToolsOzoneLexicon.Moderation.EventUnmuteReporterDefinition)

        /// An email event.
        case moderationEventEmail(ToolsOzoneLexicon.Moderation.EventEmailDefinition)

        /// A resolve appeal event.
        case moderationEventResolveAppeal(ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition)

        /// A diversion event.
        case moderationEventTag(ToolsOzoneLexicon.Moderation.EventTagDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventTakedownDefinition.self) {
                self = .moderationEventTakedown(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventReverseTakedownDefinition.self) {
                self = .moderationEventReverseTakedown(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventCommentDefinition.self) {
                self = .moderationEventComment(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventReportDefinition.self) {
                self = .moderationEventReport(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventLabelDefinition.self) {
                self = .moderationEventLabel(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventAcknowledgeDefinition.self) {
                self = .moderationEventAcknowledge(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventEscalateDefinition.self) {
                self = .moderationEventEscalate(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventMuteDefinition.self) {
                self = .moderationEventMute(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventUnmuteDefinition.self) {
                self = .moderationEventUnmute(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventMuteReporterDefinition.self) {
                self = .moderationEventMuteReporter(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventUnmuteReporterDefinition.self) {
                self = .moderationEventUnmuteReporter(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventEmailDefinition.self) {
                self = .moderationEventEmail(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventResolveAppealDefinition.self) {
                self = .moderationEventResolveAppeal(value)
            } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.EventTagDefinition.self) {
                self = .moderationEventTag(value)
            } else {
                throw DecodingError.typeMismatch(
                    EmitEventUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown EmitEventUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .moderationEventTakedown(let moderationEventTakedown):
                    try container.encode(moderationEventTakedown)
                case .moderationEventReverseTakedown(let moderationEventReverseTakedown):
                    try container.encode(moderationEventReverseTakedown)
                case .moderationEventComment(let moderationEventComment):
                    try container.encode(moderationEventComment)
                case .moderationEventReport(let moderationEventReport):
                    try container.encode(moderationEventReport)
                case .moderationEventLabel(let moderationEventLabel):
                    try container.encode(moderationEventLabel)
                case .moderationEventAcknowledge(let moderationEventAcknowledge):
                    try container.encode(moderationEventAcknowledge)
                case .moderationEventEscalate(let moderationEventEscalate):
                    try container.encode(moderationEventEscalate)
                case .moderationEventMute(let moderationEventMute):
                    try container.encode(moderationEventMute)
                case .moderationEventUnmute(let moderationEventUnmute):
                    try container.encode(moderationEventUnmute)
                case .moderationEventMuteReporter(let moderationEventMuteReporter):
                    try container.encode(moderationEventMuteReporter)
                case .moderationEventUnmuteReporter(let moderationEventUnmuteReporter):
                    try container.encode(moderationEventUnmuteReporter)
                case .moderationEventEmail(let moderationEventEmail):
                    try container.encode(moderationEventEmail)
                case .moderationEventResolveAppeal(let moderationEventResolveAppeal):
                    try container.encode(moderationEventResolveAppeal)
                case .moderationEventTag(let value):
                    try container.encode(value)
            }
        }
    }

    /// A reference containing the list of repository references.
    public enum EmitEventSubjectUnion: Codable {

        /// A repository reference.
        case repositoryReference(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition)

        /// A strong reference.
        case strongReference(ComAtprotoLexicon.Repository.StrongReference)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ComAtprotoLexicon.Admin.RepositoryReferenceDefinition.self) {
                self = .repositoryReference(value)
            } else if let value = try? container.decode(ComAtprotoLexicon.Repository.StrongReference.self) {
                self = .strongReference(value)
            } else {
                throw DecodingError.typeMismatch(
                    EmitEventSubjectUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown EmitEventSubjectUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .repositoryReference(let repositoryReference):
                    try container.encode(repositoryReference)
                case .strongReference(let strongReference):
                    try container.encode(strongReference)
            }
        }
    }
}
