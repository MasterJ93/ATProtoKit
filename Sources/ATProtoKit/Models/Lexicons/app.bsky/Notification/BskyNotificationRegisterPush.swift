//
//  BskyNotificationRegisterPush.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-27.
//

import Foundation

public struct RegisterPushRequest: Codable {
    public let serviceDID: String
    public let token: String
    public let platform: Platform
    public let appID: String

    public enum Platform: String, Codable {
        case ios
        case android
        case web
    }

    enum CodingKeys: String, CodingKey {
        case serviceDID = "serviceDid"
        case token
        case platform
        case appID = "appId"
    }
}
