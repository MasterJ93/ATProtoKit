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
}
