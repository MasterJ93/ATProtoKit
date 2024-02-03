//
//  AtProtoRepoStrongRef.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

public struct StrongReference: Codable {
    public let recordURI: String
    public let cidHash: String

    public init(recordURI: String, cidHash: String) {
        self.recordURI = recordURI
        self.cidHash = cidHash
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recordURI = try container.decode(String.self, forKey: .recordURI)
        self.cidHash = try container.decode(String.self, forKey: .cidHash)
    }

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case cidHash = "cid"
    }
}
