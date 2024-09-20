//
//  AppBskyVideoGetUploadLimits.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-16.
//

import Foundation

extension AppBskyLexicon.Video {

    /// An output model for getting the user account's current limit for videos.
    ///
    /// - Note: According to the AT Protocol specifications: "Get status details for a video
    /// processing job."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.video.getUploadLimits`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/video/getJobStatus.json
    public struct GetUploadLimitsOutput: Codable {

        /// Indicates whether the user account is able to upload videos.
        public let canUpload: Bool

        /// The remaining number of videos the user account can upload for the day. Optional.
        public let remainingDailyVideos: Int?

        /// The remaining number of bytes the user account can upload for the day. Optional.
        public let remainingDailyBytes: Int?

        /// A message attached to the limits. Optional.
        public let message: String?

        /// An error attached to the limits. Optional.
        public let error: String?
    }
}
