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

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case images
    }
}

public struct EmbedImage: Codable {
    public let image: UploadBlobOutput
    public let altText: String
    public let aspectRatio: AspectRatio?
}

public struct AspectRatio: Codable {
    public let width: Int
    public let height: Int
}

public struct EmbedImagesView: Codable {
    public let images: [ViewImage]
}

public struct ViewImage: Codable {
    public let thumbnail: String
    public let fullSize: String
    public let altText: String
    public let aspectRatio: AspectRatio?
}
