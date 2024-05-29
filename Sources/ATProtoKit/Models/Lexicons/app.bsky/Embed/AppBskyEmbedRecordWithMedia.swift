//
//  AppBskyEmbedRecordWithMedia.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation

extension AppBskyLexicon.Embed {

    /// A definition model for a record embedded with some form of compatible media.
    ///
    /// - Note: According to the AT Protocol specifications: "A representation of a record
    /// embedded in a Bluesky record (eg, a post), alongside other compatible embeds. For example,
    /// a quote post and image, or a quote post and external URL card."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.recordWithMedia][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/recordWithMedia.json
    public struct RecordWithMediaDefinition: Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.embed.recordWithMedia"

        /// The record that will be embedded.
        public let record: RecordDefinition

        /// The media of a specific type.
        public let media: ATUnion.RecordWithMediaUnion

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case record
            case media
        }

        // Enums
        /// A data model for a definition which contains an embedded record and embedded media.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.recordWithMedia`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/recordWithMedia.json
        public struct View: Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.recordWithMedia#view"

            /// The embeded record.
            public let record: AppBskyLexicon.Embed.RecordDefinition.View

            /// The embedded media.
            public let media: ATUnion.MediaViewUnion

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case record
                case media
            }
        }
    }
}
