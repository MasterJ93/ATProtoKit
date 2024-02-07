//
//  AtprotoRepoUploadBlob.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-05.
//

import Foundation

public struct ImageQuery: Encodable {
    public let imageData: Data
    public let fileName: String
    public let altText: String?
}

public struct UploadBlobOutput: Codable {
    public let type: String?
    public let reference: BlobReference
    public let mimeType: String
    public let size: Int

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case reference = "ref"
        case mimeType
        case size
    }
}

public struct BlobReference: Codable {
    public let link: String

    enum CodingKeys: String, CodingKey {
        case link = "$link"
    }
}
