//
//  BskyEmbedRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-26.
//

import Foundation

public struct EmbedRecord: Codable {
    public let record: StrongReference
}

public struct EmbedRecordView: Codable {
    public let record: RecordViewUnion

    public init(record: RecordViewUnion) {
        self.record = record
    }
}

public struct ViewRecord: Codable {
    public let recordURI: String
    public let cidHash: String
    public let author: ProfileViewBasic
    public let value: UnknownType
    public let labels: [Label]?
    public let embeds: [RecordViewUnion]?
    @DateFormatting public var indexedAt: Date

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case cidHash = "cid"
        case author
        case value = "value"
        case labels = "labels"
        case embeds = "embeds"
        case indexedAt
    }
}

public struct ViewNotFound: Codable {
    public let recordURI: String
    public let isNotFound: Bool

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case isNotFound = "notFound"
    }
}

public struct ViewBlocked: Codable {
    public let recordURI: String
    public let isBlocked: Bool
    public let author: BlockedAuthor

    enum CodingKeys: String, CodingKey {
        case recordURI = "uri"
        case isBlocked = "blocked"
        case author = "author"
    }
}

public enum RecordViewUnion: Codable {
    case viewRecord(ViewRecord)
    case viewNotFound(ViewNotFound)
    case viewBlocked(ViewBlocked)
    case generatorView(GeneratorView)
    case listView(ListView)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(ViewRecord.self) {
            self = .viewRecord(value)
        } else if let value = try? container.decode(ViewNotFound.self) {
            self = .viewNotFound(value)
        } else if let value = try? container.decode(ViewBlocked.self) {
            self = .viewBlocked(value)
        } else if let value = try? container.decode(GeneratorView.self) {
            self = .generatorView(value)
        } else if let value = try? container.decode(ListView.self) {
            self = .listView(value)
        } else {
            throw DecodingError.typeMismatch(RecordViewUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown RecordViewUnion type"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .viewRecord(let viewRecord):
                try container.encode(viewRecord)
            case .viewNotFound(let viewRecord):
                try container.encode(viewRecord)
            case .viewBlocked(let viewRecord):
                try container.encode(viewRecord)
            case .generatorView(let viewRecord):
                try container.encode(viewRecord)
            case .listView(let viewRecord):
                try container.encode(viewRecord)
        }
    }
}
