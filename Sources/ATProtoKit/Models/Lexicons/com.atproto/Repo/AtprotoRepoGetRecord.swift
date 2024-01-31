//
//  AtprotoRepoGetRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-29.
//

import Foundation

public struct RecordQuery: Codable {
    public let repo: String
    public let collection: String
    public let recordKey: String
    public let recordCID: String?

    enum CodingKeys: String, CodingKey {
        case repo = "repo"
        case collection = "collection"
        case recordKey = "rkey"
        case recordCID = "cid"
    }
}

public struct RecordOutput: Codable {
    public let atURI: String
    public let recordCID: String
    public let value: RecordValueReply?

    enum CodingKeys: String, CodingKey {
        case atURI = "uri"
        case recordCID = "cid"
        case value = "value"
    }
}

public struct RecordValueReply: Codable {
    public let reply: ReplyReference
}
