//
//  BskyEmbedImages.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-26.
//

import Foundation

public struct EmbedImages: Codable {
    public let type: String = "app.bsky.embed.images"
    public let images: [EmbedImage]

    public init(images: [EmbedImage]) {
        self.images = images
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case images
    }
}

public struct EmbedImage: Codable {
    public let image: UploadBlobOutput
    public let altText: String
    public let aspectRatio: AspectRatio?

    public init(image: UploadBlobOutput, altText: String, aspectRatio: AspectRatio?) {
        self.image = image
        self.altText = altText
        self.aspectRatio = aspectRatio
    }
}

public struct AspectRatio: Codable {
    public let width: Int
    public let height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

public struct EmbedImagesView: Codable {
    public let images: [ViewImage]

    public init(images: [ViewImage]) {
        self.images = images
    }
}

public struct ViewImage: Codable {
    public let thumbnail: String
    public let fullSize: String
    public let altText: String
    public let aspectRatio: AspectRatio?

    public init(thumbnail: String, fullSize: String, altText: String, aspectRatio: AspectRatio?) {
        self.thumbnail = thumbnail
        self.fullSize = fullSize
        self.altText = altText
        self.aspectRatio = aspectRatio
    }
}
