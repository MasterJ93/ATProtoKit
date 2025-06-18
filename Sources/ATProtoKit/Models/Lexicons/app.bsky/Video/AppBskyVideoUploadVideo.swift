//
//  AppBskyVideoUploadVideo.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-16.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Video {

    /// A request body model for uploading a video to a user's account.
    ///
    /// - Note: According to the AT Protocol specifications: "Upload a video to be processed
    /// then stored on the PDS."
    /// - SeeAlso: This is based on the [`app.bsky.video.uploadVideo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/video/getUploadLimits.json
    public struct UploadVideoRequestBody: Sendable, Codable {

        /// The video file itself.
        public let video: Data
    }

    /// An output model for uploading a video to a user's account.
    ///
    /// - Note: According to the AT Protocol specifications: "Upload a video to be processed
    /// then stored on the PDS."
    /// - SeeAlso: This is based on the [`app.bsky.video.uploadVideo`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/video/getUploadLimits.json
    public struct UploadVideoOutput: Sendable, Codable {

        /// An array of job statuses.
        public let jobStatus: AppBskyLexicon.Video.JobStatusDefinition
    }
}
