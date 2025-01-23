//
//  AppBskyVideoDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-16.
//

import Foundation

extension AppBskyLexicon.Video {

    /// A definition model for the job status of an upload.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.video.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/video/defs.json
    public struct JobStatusDefinition: Sendable, Codable {

        /// The job's ID.
        public let jobID: String

        /// The decentralized identitifier (DID) that's responsible for the job.
        public let did: String

        /// The state of the video processing job.
        ///
        /// - Note: According to the AT Protocol specifications: "The state of the video
        /// processing job. All values not listed as a known value indicate that the job is
        /// in process."
        public let state: State

        /// The progress of the job. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Progress within the current
        /// processing state."
        public let progress: Int?

        /// The video itself that's being processed. Optional.
        public let blob: ComAtprotoLexicon.Repository.UploadBlobOutput?

        /// The error code of the job. Optional.
        public let error: String?

        /// The message of the job. Optional.
        public let message: String?

        enum CodingKeys: String, CodingKey {
            case jobID = "jobId"
            case did
            case state
            case progress
            case blob
            case error
            case message
        }

        /// The state of the video processing job.
        public enum State: String, Sendable, Codable {

            /// The job has been created.
            case jobStateCreated = "JOB_STATE_CREATED"

            /// The job is currently encoding.
            case jobStateEncoding = "JOB_STATE_ENCODING"

            /// The job is currently scanning.
            case jobStateScanning = "JOB_STATE_SCANNING"
            
            /// The job is scanned.
            case jobStateScanned = "JOB_STATE_SCANNED"

            /// The job is completed processing.
            case jobStateCompleted = "JOB_STATE_COMPLETED"

            /// The job failed to complete the processing.
            case jobStateFailed = "JOB_STATE_FAILED"
        }
    }
}
