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

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case cidHash = "cid"
    }
}
