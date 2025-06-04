//
//  APIHostname.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-02.
//

import Foundation

/// A list of hostnames used for the AT Protocol.
public enum APIHostname {

    /// The hostname for Bluesky's Relay ("https://bsky.network").
    public static let relay: String = "https://bsky.network"

    /// The hostname for Bluesky's proxy entryway ("https://bsky.social").
    public static let entryway: String = "https://bsky.social"

    /// The hostname for Bluesky's AppView ("https://public.api.bsky.app").
    public static let bskyAppView: String = "https://public.api.bsky.app"

    /// The hostname for Bluesky's chat API ("https://api.bsky.chat").
    public static let bskyChat: String = "https://api.bsky.chat"

    /// The hostname for the Ozone moderation API ("https://mod.bsky.app").
    public static let moderation: String = "https://mod.bsky.app"
}
