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

    public init(imageData: Data, fileName: String, altText: String?) {
        self.imageData = imageData
        self.fileName = fileName
        self.altText = altText
    }
}

// This will be here until a way to remove this without the issues of
// the JSON encoding are solved.
public struct BlobContainer: Codable {
    public let blob: UploadBlobOutput
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
