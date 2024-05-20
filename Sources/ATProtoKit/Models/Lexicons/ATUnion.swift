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
//                print("EmbedView.embedRecordView is about to be read.")
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

    /// A reference containing the list of types of embeds.
    public enum EmbedUnion: Codable {

        /// An image embed.
        case images(AppBskyLexicon.Embed.ImagesDefinition)

        /// An external embed.
        case external(AppBskyLexicon.Embed.ExternalDefinition)

        /// A record embed.
        case record(AppBskyLexicon.Embed.RecordDefinition)

        /// A embed with both a record and some compatible media.
        case recordWithMedia(AppBskyLexicon.Embed.RecordWithMediaDefinition)

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
            } else {
                throw DecodingError.typeMismatch(
                    EmbedUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown EmbedUnion type"))
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

    /// A reference containing the list of thread rules for a post.
    public enum ThreadgateUnion: Codable {

        /// The rule which states that anyone who the user account has mentioned can interact.
        case mentionRule(AppBskyLexicon.Feed.FeedThreadgateListRule)

        /// The rule which states that anyone the user account is following can interact.
        case followingRule(AppBskyLexicon.Feed.FeedThreadgateFollowingRule)

        /// The rule which states that anyone within a list can interact.
        case listRule(AppBskyLexicon.Feed.FeedThreadgateListRule)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AppBskyLexicon.Feed.FeedThreadgateListRule.self) {
                self = .mentionRule(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.FeedThreadgateFollowingRule.self) {
                self = .followingRule(value)
            } else if let value = try? container.decode(AppBskyLexicon.Feed.FeedThreadgateListRule.self) {
                self = .listRule(value)
            } else {
                throw DecodingError.typeMismatch(
                    EmbedViewUnion.self, DecodingError.Context(
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
    public enum GraphRelationshipUnion: Codable {

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

        /// A record within the embed.
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

        /// A message view.
        case messageView(ChatBskyLexicon.Conversation.MessageViewDefinition)

        /// A deleted message view.
        case deletedMessageView(ChatBskyLexicon.Conversation.DeleteMessageViewDefinition)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ChatBskyLexicon.Conversation.MessageViewDefinition.self) {
                self = .messageView(value)
            } else if let value = try? container.decode(ChatBskyLexicon.Conversation.DeleteMessageViewDefinition.self) {
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

    /// A reference containing the list of event views.
    public enum AdminEventViewUnion: Codable {

        /// A takedown event.
        case moderationEventTakedown(OzoneModerationEventTakedown)

        /// A reverse takedown event.
        case moderationEventReverseTakedown(OzoneModerationEventReverseTakedown)

        /// A comment event.
        case moderationEventComment(OzoneModerationEventComment)

        /// A report event.
        case moderationEventReport(OzoneModerationEventReport)

        /// A label event.
        case moderationEventLabel(OzoneModerationEventLabel)

        /// An acknowledgement event.
        case moderationEventAcknowledge(OzoneModerationEventAcknowledge)

        /// An escalation event.
        case moderationEventEscalate(OzoneModerationEventEscalate)

        /// A mute event.
        case moderationEventMute(OzoneModerationEventMute)

        /// An unmute event.
        case moderationEventUnmute(OzoneModerationEventUnmute)

        /// A mute reporter event.
        case moderationEventMuteReporter(OzoneModerationEventMuteReporter)

        /// An unmute reporter event.
        case moderationEventUnmuteReporter(OzoneModerationEventUnmuteReporter)

        /// An email event.
        case moderationEventEmail(OzoneModerationEventEmail)

        /// A resolve appeal event.
        case moderationEventResolveAppeal(OzoneModerationEventResolveAppeal)

        /// A diversion event.
        case moderationEventDivert(OzoneModerationEventDivert)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(OzoneModerationEventTakedown.self) {
                self = .moderationEventTakedown(value)
            } else if let value = try? container.decode(OzoneModerationEventReverseTakedown.self) {
                self = .moderationEventReverseTakedown(value)
            } else if let value = try? container.decode(OzoneModerationEventComment.self) {
                self = .moderationEventComment(value)
            } else if let value = try? container.decode(OzoneModerationEventReport.self) {
                self = .moderationEventReport(value)
            } else if let value = try? container.decode(OzoneModerationEventLabel.self) {
                self = .moderationEventLabel(value)
            } else if let value = try? container.decode(OzoneModerationEventAcknowledge.self) {
                self = .moderationEventAcknowledge(value)
            } else if let value = try? container.decode(OzoneModerationEventEscalate.self) {
                self = .moderationEventEscalate(value)
            } else if let value = try? container.decode(OzoneModerationEventMute.self) {
                self = .moderationEventMute(value)
            } else if let value = try? container.decode(OzoneModerationEventUnmute.self) {
                self = .moderationEventUnmute(value)
            } else if let value = try? container.decode(OzoneModerationEventMuteReporter.self) {
                self = .moderationEventMuteReporter(value)
            } else if let value = try? container.decode(OzoneModerationEventUnmuteReporter.self) {
                self = .moderationEventUnmuteReporter(value)
            } else if let value = try? container.decode(OzoneModerationEventEmail.self) {
                self = .moderationEventEmail(value)
            } else if let value = try? container.decode(OzoneModerationEventResolveAppeal.self) {
                self = .moderationEventResolveAppeal(value)
            } else if let value = try? container.decode(OzoneModerationEventDivert.self) {
                self = .moderationEventDivert(value)
            } else {
                throw DecodingError.typeMismatch(
                    AdminEventViewUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown EventViewUnion type"))
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
            }
        }
    }

    /// A reference containing the list of repository references.
    public enum AdminGetSubjectStatusUnion: Codable {

        /// A repository reference.
        case repositoryReference(AdminRepositoryReference)

        /// A strong reference.
        case strongReference(StrongReference)
        /// A repository blob reference.
        case repoBlobReference(AdminRepoBlobReference)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AdminRepositoryReference.self) {
                self = .repositoryReference(value)
            } else if let value = try? container.decode(StrongReference.self) {
                self = .strongReference(value)
            } else if let value = try? container.decode(AdminRepoBlobReference.self) {
                self = .repoBlobReference(value)
            } else {
                throw DecodingError.typeMismatch(
                    AdminEventViewUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "UnknownAdminGetSubjectStatusUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .repositoryReference(let repositoryReference):
                    try container.encode(repositoryReference)
                case .strongReference(let strongReference):
                    try container.encode(strongReference)
                case .repoBlobReference(let repoBlobReference):
                    try container.encode(repoBlobReference)
            }
        }
    }

    // Create the custom init and encode methods.
    /// A reference containing the list of repository references.
    public enum RepositoryReferencesUnion: Codable {

        /// A repository reference.
        case repositoryReference(AdminRepositoryReference)

        /// A strong reference.
        case strongReference(StrongReference)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AdminRepositoryReference.self) {
                self = .repositoryReference(value)
            } else if let value = try? container.decode(StrongReference.self) {
                self = .strongReference(value)
            } else {
                throw DecodingError.typeMismatch(
                    ActorPreferenceUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown RepositoryReferencesUnion type"))
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

    // Create the custom init and encode methods.
    /// A reference containing the list of moderator events.
    public enum EventViewDetailUnion: Codable {

        /// A takedown event.
        case moderationEventTakedown(OzoneModerationEventTakedown)

        /// A reverse takedown event.
        case moderationEventReverseTakedown(OzoneModerationEventReverseTakedown)

        /// A comment event.
        case moderationEventComment(OzoneModerationEventComment)

        /// A report event.
        case moderationEventReport(OzoneModerationEventReport)

        /// A label event.
        case moderationEventLabel(OzoneModerationEventLabel)

        /// An acknowledgment event.
        case moderationEventAcknowledge(OzoneModerationEventAcknowledge)

        /// An escalation event.
        case moderationEventEscalate(OzoneModerationEventEscalate)

        /// A mute event.
        case moderationEventMute(OzoneModerationEventMute)

        /// A resolve appeal event.
        case moderationEventResolveAppeal(OzoneModerationEventResolveAppeal)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(OzoneModerationEventTakedown.self) {
                self = .moderationEventTakedown(value)
            } else if let value = try? container.decode(OzoneModerationEventReverseTakedown.self) {
                self = .moderationEventReverseTakedown(value)
            } else if let value = try? container.decode(OzoneModerationEventComment.self) {
                self = .moderationEventComment(value)
            } else if let value = try? container.decode(OzoneModerationEventReport.self) {
                self = .moderationEventReport(value)
            } else if let value = try? container.decode(OzoneModerationEventLabel.self) {
                self = .moderationEventLabel(value)
            } else if let value = try? container.decode(OzoneModerationEventAcknowledge.self) {
                self = .moderationEventAcknowledge(value)
            } else if let value = try? container.decode(OzoneModerationEventEscalate.self) {
                self = .moderationEventEscalate(value)
            } else if let value = try? container.decode(OzoneModerationEventMute.self) {
                self = .moderationEventMute(value)
            } else if let value = try? container.decode(OzoneModerationEventResolveAppeal.self) {
                self = .moderationEventResolveAppeal(value)
            } else {
                throw DecodingError.typeMismatch(
                    ActorPreferenceUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown EventViewDetailUnion type"))
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
            }
        }
    }

    // Create the custom init and encode methods.
    /// A reference containing the list of the types of repository or record views.
    public enum RepositoryViewUnion: Codable {

        /// A normal repository view.
        case repositoryView(AdminReportView)

        /// A repository view that may not have been found.
        case repositoryViewNotFound(OzoneModerationRepositoryViewNotFound)

        /// A normal record.
        case recordView(OzoneModerationRecordView)

        /// A record view that may not have been found.
        case recordViewNotFound(OzoneModerationRecordViewNotFound)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(AdminReportView.self) {
                self = .repositoryView(value)
            } else if let value = try? container.decode(OzoneModerationRepositoryViewNotFound.self) {
                self = .repositoryViewNotFound(value)
            } else if let value = try? container.decode(OzoneModerationRecordView.self) {
                self = .recordView(value)
            } else if let value = try? container.decode(OzoneModerationRecordViewNotFound.self) {
                self = .recordViewNotFound(value)
            } else {
                throw DecodingError.typeMismatch(
                    ActorPreferenceUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown RepositoryViewUnion type"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .repositoryView(let repositoryView):
                    try container.encode(repositoryView)
                case .repositoryViewNotFound(let repositoryViewNotFound):
                    try container.encode(repositoryViewNotFound)
                case .recordView(let recordView):
                    try container.encode(recordView)
                case .recordViewNotFound(let recordViewNotFound):
                    try container.encode(recordViewNotFound)
            }
        }
    }

    /// A reference containing the list of the types of media details.
    public enum MediaDetailUnion: Codable {

        /// The details for an image.
        case mediaImageDetails(OzoneModerationMediaImageDetails)

        /// The details for a video.
        case mediaVideoDetails(OzoneModerationMediaVideoDetails)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(OzoneModerationMediaImageDetails.self) {
                self = .mediaImageDetails(value)
            } else if let value = try? container.decode(OzoneModerationMediaVideoDetails.self) {
                self = .mediaVideoDetails(value)
            } else {
                throw DecodingError.typeMismatch(
                    ActorPreferenceUnion.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown MediaDetailUnion type"))
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

    /// A reference containing the list of write operations.
    public enum ApplyWritesUnion: Codable {

        /// A "Create" write operation.
        case create(RepoApplyWritesCreate)

        /// An "Update" write operation.
        case update(RepoApplyWritesUpdate)

        /// A "Delete" write operation.
        case delete(RepoApplyWritesDelete)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(RepoApplyWritesCreate.self) {
                self = .create(value)
            } else if let value = try? container.decode(RepoApplyWritesUpdate.self) {
                self = .update(value)
            } else if let value = try? container.decode(RepoApplyWritesDelete.self) {
                self = .delete(value)
            } else {
                throw DecodingError.typeMismatch(
                    EmbedViewUnion.self, DecodingError.Context(
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

    
}
