//
//  AtprotoServerDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

public struct ServerInviteCode: Codable {
    public let code: String
    public let available: Int
    public let isDisabled: Bool
    public let forAccount: String
    public let createdBy: String
    @DateFormatting public var createdAt: Date
    public let uses: [ServerInviteCodeUse]

    public init(code: String, available: Int, isDisabled: Bool, forAccount: String, createdBy: String, createdAt: Date, uses: [ServerInviteCodeUse]) {
        self.code = code
        self.available = available
        self.isDisabled = isDisabled
        self.forAccount = forAccount
        self.createdBy = createdBy
        self._createdAt = DateFormatting(wrappedValue: createdAt)
        self.uses = uses
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.code = try container.decode(String.self, forKey: .code)
        self.available = try container.decode(Int.self, forKey: .available)
        self.isDisabled = try container.decode(Bool.self, forKey: .isDisabled)
        self.forAccount = try container.decode(String.self, forKey: .forAccount)
        self.createdBy = try container.decode(String.self, forKey: .createdBy)
        self.createdAt = try container.decode(DateFormatting.self, forKey: .createdAt).wrappedValue
        self.uses = try container.decode([ServerInviteCodeUse].self, forKey: .uses)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.code, forKey: .code)
        try container.encode(self.available, forKey: .available)
        try container.encode(self.isDisabled, forKey: .isDisabled)
        try container.encode(self.forAccount, forKey: .forAccount)
        try container.encode(self.createdBy, forKey: .createdBy)
        try container.encode(self._createdAt, forKey: .createdAt)
        try container.encode(self.uses, forKey: .uses)
    }

    enum CodingKeys: String, CodingKey {
        case code
        case available
        case isDisabled = "disabled"
        case forAccount
        case createdBy
        case createdAt
        case uses
    }
}

public struct ServerInviteCodeUse: Codable {
    public let usedBy: String
    @DateFormatting public var usedAt: Date

    public init(usedBy: String, usedAt: Date) {
        self.usedBy = usedBy
        self._usedAt = DateFormatting(wrappedValue: usedAt)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.usedBy = try container.decode(String.self, forKey: .usedBy)
        self.usedAt = try container.decode(DateFormatting.self, forKey: .usedAt).wrappedValue
    }
}
