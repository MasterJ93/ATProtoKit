//
//  BskyEmbedImages.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-26.
//

import Foundation

public struct EmbedImages: Codable {
    public let images: [EmbedImage]
}

public struct EmbedImage: Codable {
    public let image: Data // Assuming binary data for 'blob' type
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
