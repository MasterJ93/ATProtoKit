//
//  AppBskyEmbedVideo.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-16.
//

import Foundation

extension AppBskyLexicon.Embed {

    /// A definition model for a video embed.
    ///
    /// - Note: According to the AT Protocol specifications: "A video embedded in a Bluesky record
    /// (eg, a post)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.video`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/video.json
    public struct VideoDefinition: Sendable, Codable, Equatable, Hashable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.embed.video"

        /// The video itself.
        ///
        /// Only .mp4 files can be accepted.
        ///
        /// - Important: Current maximum size is 100,000,000 bytes (100 MB).
        ///
        /// - Note: According to the AT Protocol specifications: "The mp4 video file. May be up to
        /// 100mb, formerly limited to 50mb."
        public let video: ComAtprotoLexicon.Repository.UploadBlobOutput

        /// An array of captions in various languages provided for the video. Optional.
        ///
        /// - Important: Current maximum length is 20 items.
        ///
        /// - Note: According to the AT Protocol specifications: "Alt text description of the
        /// video, for accessibility."
        public let captions: [Caption]?

        /// The alt text provided for the video. Optional.
        ///
        /// - Important: Current maximum length is 1,000 characters.
        public let altText: String?

        /// The aspect ratio of the video. Optional.
        public let aspectRatio: AspectRatioDefinition?

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.type, forKey: .type)
            try container.encode(self.video, forKey: .video)
            try container.truncatedEncodeIfPresent(self.captions, forKey: .captions, upToArrayLength: 20)
            try container.encodeIfPresent(self.altText, forKey: .altText)
            try container.encodeIfPresent(self.aspectRatio, forKey: .aspectRatio)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case video
            case captions
            case altText = "alt"
            case aspectRatio
        }

        /// A data model for captions.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.video`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/video.json
        public struct Caption: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.video#caption"

            /// The language the captions are written in.
            public let language: String

            /// The caption file itself.
            ///
            /// - Important: The file must be in a .vtt format and can not exceed
            /// 20,000 bytes (or 2 KB).
            public let fileBlob: ComAtprotoLexicon.Repository.UploadBlobOutput

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case language = "lang"
                case fileBlob = "file"
            }
        }

        /// A data model for the video view.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.video`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/video.json
        public struct View: Sendable, Codable, Equatable, Hashable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.video#view"

            /// The CID hash of the video.
            public let cid: String

            /// The playlist the video resides in.
            public let playlistURI: String

            /// The thumbnail URL for the video. Optional.
            public let thumbnailImageURL: String?

            /// The alt text provided for the video. Optional.
            public let altText: String?

            /// The aspect ratio of the video. Optional.
            public let aspectRatio: AspectRatioDefinition?

            public init(cid: String, playlistURI: String, thumbnailImageURL: String?, altText: String?, aspectRatio: AspectRatioDefinition?) {
                self.cid = cid
                self.playlistURI = playlistURI
                self.thumbnailImageURL = thumbnailImageURL
                self.altText = altText
                self.aspectRatio = aspectRatio
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.cid = try container.decode(String.self, forKey: .cid)
                self.playlistURI = try container.decode(String.self, forKey: .playlistURI)
                self.thumbnailImageURL = try container.decodeIfPresent(String.self, forKey: .thumbnailImageURL)
                self.altText = try container.decodeIfPresent(String.self, forKey: .altText)
                self.aspectRatio = try container.decodeIfPresent(AppBskyLexicon.Embed.AspectRatioDefinition.self, forKey: .aspectRatio)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.type, forKey: .type)
                try container.encode(self.cid, forKey: .cid)
                try container.encode(self.playlistURI, forKey: .playlistURI)
                try container.encodeIfPresent(self.thumbnailImageURL, forKey: .thumbnailImageURL)
                try container.encodeIfPresent(self.altText, forKey: .altText)
                try container.encodeIfPresent(self.aspectRatio, forKey: .aspectRatio)
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case cid
                case playlistURI = "playlist"
                case thumbnailImageURL = "thumbnail"
                case altText = "alt"
                case aspectRatio
            }
        }
    }
}
