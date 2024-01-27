//
//  BskyEmbedExternal.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-26.
//

import Foundation

public struct EmbedExternal: Codable {
    public let external: External
}

public struct External: Codable {
    public let embedURI: String
    public let title: String
    public let description: String
    public let thumbnail: Data
}

public struct EmbedExternalView: Codable {
    public let external: ViewExternal
}

public struct ViewExternal: Codable {
    public let embedURI: String
    public let title: String
    public let description: String
    public let thumbnail: String?
}
