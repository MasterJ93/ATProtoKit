//
//  AppBskyEmbedImages.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation

extension AppBskyLexicon.Embed {

    /// The main data model definition for image embeds.
    ///
    /// - Note: According to the AT Protocol specifications: "A set of images embedded in a Bluesky
    /// record (eg, a post)."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.images`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
    public struct ImagesDefinition: Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public let type: String = "app.bsky.embed.images"

        /// An array of images to embed.
        ///
        ///- Note: Current maximum upload count is 4 images.
        public let images: [Image]
        
        public init(images: [Image]) {
            self.images = images
        }
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case images
        }
    }
    
    // MARK: -
    /// A data model for an external definition.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.images`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
    public struct Image: Codable {

        /// The image that needs to be uploaded.
        ///
        /// - Warning: The image size can't be higher than 1 MB. Failure to do so will result in
        /// the image failing to upload.
        public let image: UploadBlobOutput

        /// The alternative text for the image.
        ///
        /// - Note: From the AT Protocol specification: "Alt text description of the image,
        /// for accessibility."
        public let altText: String

        /// The aspect ratio of the image. Optional.
        public let aspectRatio: AspectRatio?
        
        public init(image: UploadBlobOutput, altText: String, aspectRatio: AspectRatio?) {
            self.image = image
            self.altText = altText
            self.aspectRatio = aspectRatio
        }
        
        enum CodingKeys: String, CodingKey {
            case image
            case altText = "alt"
            case aspectRatio
        }
    }
    
    /// A data model for the aspect ratio definition.
    ///
    /// - Note: From the AT Protocol specification: "width:height represents an aspect ratio.
    /// It may be approximate, and may not correspond to absolute dimensions in any given unit."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.images`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
    public struct AspectRatio: Codable {

        /// The width of the image.
        public let width: Int

        /// The height of the image.
        public let height: Int
        
        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }
    
    /// A data model for the embed images definition.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.images`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
    public struct ImagesView: Codable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        //    public let type: String = "app.bsky.embed.images#view"
        /// An array of images to be viewed.
        public let images: [ViewImage]
    }
    
    /// A data model for a definition related to viewing an image.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.embed.images`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
    public struct ViewImage: Codable {

        /// The URI of the image's thumbnail.
        ///
        /// - Note: From the AT Protocol specification: "Fully-qualified URL where a thumbnail of
        /// the image can be fetched. For example, CDN location provided by the App View."
        public let thumbnailImageURL: URL

        /// The URI of the fully-sized image.
        ///
        /// - Note: From the AT Protocol specification: "Fully-qualified URL where a large version
        /// of the image can be fetched. May or may not be the exact original blob. For example,
        /// CDN location provided by the App View."
        public let fullSizeImageURL: URL

        /// /// The alternative text for the image.
        ///
        /// - Note: From the AT Protocol specification: "Alt text description of the image,
        /// for accessibility."
        public let altText: String

        /// The aspect ratio of the image. Optional.
        public let aspectRatio: AspectRatio?
        
        public init(thumbnailImageURL: URL, fullSizeImageURL: URL, altText: String, aspectRatio: AspectRatio?) {
            self.thumbnailImageURL = thumbnailImageURL
            self.fullSizeImageURL = fullSizeImageURL
            self.altText = altText
            self.aspectRatio = aspectRatio
        }
        
        enum CodingKeys: String, CodingKey {
            case thumbnailImageURL = "thumb"
            case fullSizeImageURL = "fullsize"
            case altText = "alt"
            case aspectRatio
        }
    }

}
