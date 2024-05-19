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
        /// The Hidden Posts" preference.
        case hiddenPostsPreferences(AppBskyLexicon.Actor.HiddenPostsPreferencesDefinition)

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
            }
        }
    }

    /// A reference containing the list of the status of a record.
    public enum RecordViewUnion: Codable {
        /// A normal record type.
        case viewRecord(AppBskyLexicon.Embed.ViewRecord)
        /// A record that may not have been found.
        case viewNotFound(AppBskyLexicon.Embed.ViewNotFound)
        /// A record that may have been blocked.
        case viewBlocked(AppBskyLexicon.Embed.ViewBlocked)
        /// A generator view.
        case generatorView(AppBskyLexicon.Feed.GeneratorViewDefinition)
        /// A list view.
        case listView(AppBskyLexicon.Graph.ListViewDefinition)
        /// A labeler view.
        case labelerView(AppBskyLexicon.Labeler.LabelerViewDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.ViewRecord.self) {
                self = .viewRecord(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.ViewNotFound.self) {
                self = .viewNotFound(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.ViewBlocked.self) {
                self = .viewBlocked(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.GeneratorViewDefinition.self) {
                self = .generatorView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Graph.ListViewDefinition.self) {
                self = .listView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Labeler.LabelerViewDefinition.self) {
                self = .labelerView(value)
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
                case .generatorView(let generatorView):
                    try container.encode(generatorView)
                case .listView(let listView):
                    try container.encode(listView)
                case .labelerView(let labelerView):
                    try container.encode(labelerView)
            }
        }
    }

    /// A reference containing the list of the types of compatible media.
    public enum MediaUnion: Codable {
        /// An image that will be embedded.
        case embedImages(AppBskyLexicon.Embed.ImagesDefinition)
        /// An external link that will be embedded.
        case embedExternal(AppBskyLexicon.Embed.ExternalDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.ImagesDefinition.self) {
                self = .embedImages(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.ExternalDefinition.self) {
                self = .embedExternal(value)
            } else {
                throw DecodingError.typeMismatch(
                    PostUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MediaUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .embedImages(let media):
                    try container.encode(media)
                case .embedExternal(let media):
                    try container.encode(media)
            }
        }
    }

    /// A reference containing the list of the types of compatible media that can be viewed.
    public enum MediaViewUnion: Codable {
        /// An image that's been embedded.
        case embedImagesView(AppBskyLexicon.Embed.ImagesView)
        /// An external link that's been embedded.
        case embedExternalView(AppBskyLexicon.Embed.ExternalView)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.ImagesView.self) {
                self = .embedImagesView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.ExternalView.self) {
                self = .embedExternalView(value)
            } else {
                throw DecodingError.typeMismatch(
                    PostUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MediaViewUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .embedImagesView(let mediaView):
                    try container.encode(mediaView)
                case .embedExternalView(let mediaView):
                    try container.encode(mediaView)
            }
        }
    }

    /// A reference containing the list of the types of embeds.
    public enum EmbedViewUnion: Codable {
        /// The view of an external embed.
        case embedExternalView(AppBskyLexicon.Embed.ExternalView)
        /// The view of an image embed.
        case embedImagesView(AppBskyLexicon.Embed.ImagesView)
        /// The view of a record embed.
        case embedRecordView(AppBskyLexicon.Embed.RecordView)
        /// The view of a record embed alongside an embed of some compatible media.
        case embedRecordWithMediaView(AppBskyLexicon.Embed.RecordWithMediaView)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.ExternalView.self) {
                self = .embedExternalView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.ImagesView.self) {
                self = .embedImagesView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.RecordView.self) {
                print("EmbedView.embedRecordView is about to be read.")
                self = .embedRecordView(value)
            } else if let value = try? container.decode(AppBskyLexicon.Embed.RecordWithMediaView.self) {
                self = .embedRecordWithMediaView(value)
            } else {
                throw DecodingError.typeMismatch(
                    EmbedViewUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown EmbedView type"))
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
            }
        }
    }

    /// A reference containing the list of the states of a post.
    public enum PostUnion: Codable {
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
                    PostUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown PostUnion type"))
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
    public indirect enum ThreadPostUnion: Codable {
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
                    ThreadPostUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown ThreadPostUnion type"))
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

    /// A reference containing the list of the state of a post thread.
    public enum FeedGetPostThreadUnion: Codable {
        /// A post thread.
        case threadViewPost(AppBskyLexicon.Feed.ThreadViewPostDefinition)
        /// The post thread wasn't found.
        case notFoundPost(AppBskyLexicon.Feed.NotFoundPostDefinition)
        /// The post thread was made by someone who blocked the user account.
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
                    FeedGetPostThreadUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown FeedGetPostThread type"))
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

    /// A reference containing the list of user-defined labels.
    public enum FeedLabelUnion: Codable {
        /// An array of user-defined labels.
        case selfLabels(SelfLabels)

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let selfLabelsValue = try container.decode(SelfLabels.self, forKey: .selfLabels)
            self = .selfLabels(selfLabelsValue)
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

    /// A reference containing the list of relationships of multiple user accounts.
    public enum GraphRelationshipUnion: Codable {
        case relationship(AppBskyLexicon.Graph.RelationshipDefinition)
        case notFoundActor(AppBskyLexicon.Graph.NotFoundActorDefinition)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Graph.RelationshipDefinition.self) {
                self = .relationship(value)
            } else if let value = try? container.decode(AppBskyLexicon.Graph.NotFoundActorDefinition.self) {
                self = .notFoundActor(value)
            } else {
                throw DecodingError.typeMismatch(
                    ActorPreferenceUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown GraphRelationshipUnion type"))
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
    public enum LabelerViewUnion: Codable {
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
                    ActorPreferenceUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown LabelerViewUnion type"))
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
    public enum FeatureUnion: Codable {
        /// The Mention feature.
        case mention(AppBskyLexicon.RichText.Mention)
        /// The Link feature.
        case link(AppBskyLexicon.RichText.Link)
        /// The Tag feature.
        case tag(AppBskyLexicon.RichText.Tag)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.RichText.Mention.self) {
                self = .mention(value)
            } else if let value = try? container.decode(AppBskyLexicon.RichText.Link.self) {
                self = .link(value)
            } else if let value = try? container.decode(AppBskyLexicon.RichText.Tag.self) {
                self = .tag(value)
            } else {
                throw DecodingError.typeMismatch(
                    FeatureUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown FeatureUnion type"))
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

    

    /// A reference containing the list of message embeds.
    public enum MessageEmbedUnion: Codable {
        case record(AppBskyLexicon.Embed.RecordDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.self) {
                self = .record(value)
            } else {
                throw DecodingError.typeMismatch(
                    MessageEmbedUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MessageEmbedUnion type"))
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
    public enum MessageViewUnion: Codable {
        case messageView(ChatBskyLexicon.Conversation.MessageView)
        case deletedMessageView(ChatBskyLexicon.Conversation.DeleteMessageView)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageView.self) {
                self = .messageView(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeleteMessageView.self) {
                self = .deletedMessageView(value)
            } else {
                throw DecodingError.typeMismatch(
                    MessageViewUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MessageViewUnion type"))
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
        case logBeginConversation(ChatBskyLexicon.Conversation.LogBeginConversation)
        case logLeaveConversation(ChatBskyLexicon.Conversation.LogLeaveConversation)
        case logCreateMessage(ChatBskyLexicon.Conversation.LogCreateMessage)
        case logDeleteMessage(ChatBskyLexicon.Conversation.LogDeleteMessage)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.LogBeginConversation.self) {
                self = .logBeginConversation(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogLeaveConversation.self) {
                self = .logLeaveConversation(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogCreateMessage.self) {
                self = .logCreateMessage(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.LogDeleteMessage.self) {
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
}
