//
//  AppBskyNotificationDefs.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-14.
//

import Foundation

extension AppBskyLexicon.Notification {

    /// A definition model for a deleted record.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/defs.json
    public struct RecordDeletedDefinition: Sendable, Codable {}
}
