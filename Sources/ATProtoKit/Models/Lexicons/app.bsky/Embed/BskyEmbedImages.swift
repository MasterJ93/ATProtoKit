//
//  BskyEmbedImages.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-26.
//

import Foundation

// MARK: - Main definition
/// The main data model definition for image embeds.
///
/// - Note: This is based on the `app.bsky.embed.images` lexicon.
///
/// The lexicon can be viewed in their [GitHub repo][github].
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
public struct EmbedImages: Codable {
    /// The identifier of the lexicon.
    ///
    /// - Warning: The value must not change.
    public let type: String = "app.bsky.embed.images"
    /// An array of images to embed.
    public let images: [EmbedImage]

    public init(images: [EmbedImage]) {
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
/// - Note: This is based on the `app.bsky.embed.images` lexicon.
///
/// The lexicon can be viewed in their [GitHub repo][github].
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
public struct EmbedImage: Codable {
    /// The image that needs to be uploaded.
    ///
    /// - Warning: The image size can't be higher than 1 MB. Failure to do so will result in the image failing to upload.
    public let image: UploadBlobOutput
    /// The alternative text for the image.
    ///
    /// - Note: From the AT Protocol specification: "Alt text description of the image, for accessibility."
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
/// - Note: From the AT Protocol specification: "width:height represents an aspect ratio. It may be approximate, and may not
/// correspond to absolute dimensions in any given unit."
/// - Note: This is based on the `app.bsky.embed.images` lexicon.
///
/// The lexicon can be viewed in their [GitHub repo][github].
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
/// - Note: This is based on the `app.bsky.embed.images` lexicon.
///
/// The lexicon can be viewed in their [GitHub repo][github].
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
public struct EmbedImagesView: Codable {
    /// An array of images to be viewed.
    public let images: [ViewImage]

    public init(images: [ViewImage]) {
        self.images = images
    }
}

/// A data model for a definition related to viewing an image.
///
/// - Note: This is based on the `app.bsky.embed.images` lexicon.
///
/// The lexicon can be viewed in their [GitHub repo][github].
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
public struct ViewImage: Codable {
    /// The URI of the image's thumbnail.
    ///
    /// - Note: From the AT Protocol specification: "Fully-qualified URL where a thumbnail of the image can be fetched.
    /// For example, CDN location provided by the App View."
    public let thumbnail: String
    /// The URI of the fully-sized image.
    ///
    /// - Note: From the AT Protocol specification: "Fully-qualified URL where a large version of the image can be fetched.
    /// May or may not be the exact original blob. For example, CDN location provided by the App View."
    public let fullSize: String
    /// /// The alternative text for the image.
    ///
    /// - Note: From the AT Protocol specification: "Alt text description of the image, for accessibility."
    public let altText: String
    /// The aspect ratio of the image. Optional.
    public let aspectRatio: AspectRatio?

    public init(thumbnail: String, fullSize: String, altText: String, aspectRatio: AspectRatio?) {
        self.thumbnail = thumbnail
        self.fullSize = fullSize
        self.altText = altText
        self.aspectRatio = aspectRatio
    }
}
