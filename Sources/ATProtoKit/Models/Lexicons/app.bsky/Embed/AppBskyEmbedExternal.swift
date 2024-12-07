//
//  AppBskyEmbedExternal.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation

extension AppBskyLexicon.Embed {

    /// A definition model for external embeds.
    ///
    /// - Note: According to the AT Protocol specifications: "A representation of some externally
    /// linked content (eg, a URL and 'card'), embedded in a Bluesky record (eg, a post)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
    public struct ExternalDefinition: Sendable, Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.embed.external"

        /// The external content needed to be embeeded.
        public let external: External

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case external
        }

        // Enums
        /// An external embed object.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
        public struct External: Sendable, Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#external"

            /// The URI of the external content.
            public let embedURI: URL

            /// The title of the external content.
            public let title: String

            /// The description of the external content.
            public let description: String

            /// The thumbnail image of the external content.
            ///
            /// - Warning: The image size can't be higher than 1 MB. Failure to do so will result
            /// in the image failing to upload.
            public let thumbnailImage: ComAtprotoLexicon.Repository.UploadBlobOutput?

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case embedURI = "uri"
                case title
                case description
                case thumbnailImage = "thumb"
            }
        }

        /// A data model for an external view definition.
        ///
        /// - SeeAlso: This is based on the [`app.bsky.embed.external`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
        public struct View: Sendable, Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#view"

            /// The external content embedded in a post.
            public let external: ViewExternal

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case external
            }
        }

        /// A data model for a definition for the external content.
        public struct ViewExternal: Sendable, Codable {

            /// The identifier of the lexicon.
            ///
            /// - Warning: The value must not change.
            public let type: String = "app.bsky.embed.external#viewExternal"

            /// The URI of the external content.
            public let embedURI: String

            /// The title of the external content.
            public let title: String

            /// The description of the external content.
            public let description: String

            /// The thumbnail image URL of the external content.
            public let thumbnailImageURL: URL?

            enum CodingKeys: String, CodingKey {
                case type = "$type"
                case embedURI = "uri"
                case title
                case description
                case thumbnailImageURL = "thumb"
            }
        }
    }
}
