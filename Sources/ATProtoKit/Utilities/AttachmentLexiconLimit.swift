//
//  AttachmentLexiconLimit.swift
//
//
//  Created by Christopher Jr Riley on 2026-06-27.
//

import Foundation

/// The maximum blob sizes (in bytes) for post attachments, as declared by their
/// respective lexicons.
///
/// Each value mirrors the `maxSize` constraint of the lexicon that governs the attachment.
/// Routing every size guard through this type keeps the limits in a single place, so a future
/// lexicon relaxation is a one-line change instead of a hunt for inlined magic numbers.
public enum AttachmentLexiconLimit {

    /// The maximum size of a post image embed: 2,000,000 bytes.
    ///
    /// Declared by `app.bsky.embed.images` at `defs.image.properties.image.maxSize`.
    ///
    /// - SeeAlso: [`app.bsky.embed.images`][images] lexicon.
    ///
    /// [images]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
    public static let postImageEmbed = 2_000_000

    /// The maximum size of an external link thumbnail: 1,000,000 bytes.
    ///
    /// Declared by `app.bsky.embed.external` at `defs.external.properties.thumb.maxSize`.
    ///
    /// - SeeAlso: [`app.bsky.embed.external`][external] lexicon.
    ///
    /// [external]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/external.json
    public static let externalEmbedThumbnail = 1_000_000

    /// The maximum size of a profile avatar: 1,000,000 bytes.
    ///
    /// Declared by `app.bsky.actor.profile` at `defs.main.record.properties.avatar.maxSize`.
    ///
    /// - SeeAlso: [`app.bsky.actor.profile`][profile] lexicon.
    ///
    /// [profile]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/profile.json
    public static let profileAvatar = 1_000_000

    /// The maximum size of a profile banner: 1,000,000 bytes.
    ///
    /// Declared by `app.bsky.actor.profile` at `defs.main.record.properties.banner.maxSize`.
    ///
    /// - SeeAlso: [`app.bsky.actor.profile`][profile] lexicon.
    ///
    /// [profile]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/profile.json
    public static let profileBanner = 1_000_000

    /// The maximum size of a list avatar: 1,000,000 bytes.
    ///
    /// Declared by `app.bsky.graph.list` at `defs.main.record.properties.avatar.maxSize`.
    ///
    /// - SeeAlso: [`app.bsky.graph.list`][list] lexicon.
    ///
    /// [list]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/graph/list.json
    public static let listAvatar = 1_000_000

    /// The maximum size of a video embed: 100,000,000 bytes.
    ///
    /// Declared by `app.bsky.embed.video` at `defs.main.properties.video.maxSize`.
    ///
    /// - SeeAlso: [`app.bsky.embed.video`][video] lexicon.
    ///
    /// [video]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/video.json
    public static let videoEmbed = 100_000_000

    /// The maximum size of a video VTT caption file: 20,000 bytes.
    ///
    /// Declared by `app.bsky.embed.video` at `defs.caption.properties.file.maxSize`.
    ///
    /// - SeeAlso: [`app.bsky.embed.video`][video] lexicon.
    ///
    /// [video]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/video.json
    public static let videoVTTCaption = 20_000

    // The daily video upload quota is server-driven via `app.bsky.video.getUploadLimits`
    // and is therefore not represented here.
}
