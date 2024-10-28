//
//  AppBskyVideoGetJobStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-16.
//

import Foundation

extension AppBskyLexicon.Video {

    /// An output model for the video's job status.
    ///
    /// - Note: According to the AT Protocol specifications: "Get status details for a video
    /// processing job"
    ///
    /// - SeeAlso: This is based on the [`app.bsky.video.getJobStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/video/getJobStatus.json
    public struct GetJobStatusOutput: Sendable, Codable {

        /// The status of the video processing job.
        public let jobStatus: AppBskyLexicon.Video.JobStatusDefinition
    }
}
