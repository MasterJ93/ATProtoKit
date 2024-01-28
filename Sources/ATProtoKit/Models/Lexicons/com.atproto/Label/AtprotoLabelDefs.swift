//
//  AtProtoLabelDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

public struct Label: Codable {
    public let actorDID: String
    public let atURI: String
    public let cidHash: String?
    public var name: String
    public let isNegated: Bool?
    @DateFormatting public var timestamp: Date

    public init(actorDID: String, atURI: String, cidHash: String?, name: String, isNegated: Bool?, timestamp: Date) {
        self.actorDID = actorDID
        self.atURI = atURI
        self.cidHash = cidHash
        self.name = name
        self.isNegated = isNegated
        self._timestamp = DateFormatting(wrappedValue: timestamp)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.actorDID = try container.decode(String.self, forKey: .actorDID)
        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decodeIfPresent(String.self, forKey: .cidHash)
        self.name = try container.decode(String.self, forKey: .name)
        self.isNegated = try container.decodeIfPresent(Bool.self, forKey: .isNegated)
        self._timestamp = try container.decode(DateFormatting.self, forKey: .timestamp)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.actorDID, forKey: .actorDID)
        try container.encode(self.atURI, forKey: .atURI)
        try container.encodeIfPresent(self.cidHash, forKey: .cidHash)

        // Truncate `name` to 128 characters before encoding
        try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToLength: 128)

        try container.encodeIfPresent(self.isNegated, forKey: .isNegated)
        try container.encode(self._timestamp, forKey: .timestamp)
    }

    enum CodingKeys: String, CodingKey {
        case actorDID = "src"
        case atURI = "uri"
        case cidHash = "cid"
        case name = "val"
        case isNegated = "neg"
        case timestamp = "cts"
    }
}

public struct SelfLabels: Codable {
    public let values: [SelfLabel]

    public init(values: [SelfLabel]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.values = try container.decode([SelfLabel].self, forKey: .values)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Truncate `values` to 10 items before encoding
        try truncatedEncode(self.values, withContainer: &container, forKey: .values, upToLength: 10)
    }

    enum CodingKeys: CodingKey {
        case values
    }
}

public struct SelfLabel: Codable {
    public let value: String

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Truncate `value` to 128 characters before encoding
        try truncatedEncode(self.value, withContainer: &container, forKey: .value, upToLength: 128)
    }

    enum CodingKeys: String, CodingKey {
        case value = "val"
    }
}
