//
//  APIHostname.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-02.
//

import Foundation

/// A list of hostnames used for the AT Protocol.
public enum APIHostname {

    /// The hostname for Bluesky's Relay.
    public static let relay: String = "https://bsky.network"

    /// The hostname for Bluesky's proxy entryway.
    public static let entryway: String = "https://bsky.social"

    /// The hostname for Bluesky's AppView.
    public static let bskyAppView = "https://api.bsky.app"

    /// The hostname for Bluesky's chat API.
    public static let bskyChat = "https://api.bsky.chat"

    /// The hostname for the Ozone moderation API.
    public static let moderation = "https://mod.bsky.app"
}
