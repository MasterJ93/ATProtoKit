//
//  AppBskyVideoDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-16.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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

            /// The job is encoded.
            case jobStateEncoded = "JOB_STATE_ENCODED"

            /// The job is currently scanning.
            case jobStateScanning = "JOB_STATE_SCANNING"
            
            /// The job is scanned.
            case jobStateScanned = "JOB_STATE_SCANNED"

            /// The job is currently uploading.
            case jobStateUploading = "JOB_STATE_UPLOADING"

            /// The job is uploaded.
            case jobStateUploaded = "JOB_STATE_UPLOADED"

            /// The job is completed processing.
            case jobStateCompleted = "JOB_STATE_COMPLETED"

            /// The job failed to complete the processing.
            case jobStateFailed = "JOB_STATE_FAILED"

            /// A state this version of the lexicon does not name.
            ///
            /// `app.bsky.video.defs` declares `state` as an open set: "All values
            /// not listed as a known value indicate that the job is in process."
            /// Decoding an unrecognised value as an error fails the whole upload
            /// the moment the service reports a state added after this type was
            /// written, so anything unknown lands here and callers treat it the
            /// same as any other in-progress state.
            case jobStateInProcess = "JOB_STATE_IN_PROCESS"

            public init(from decoder: any Decoder) throws {
                let rawValue = try decoder.singleValueContainer().decode(String.self)
                self = State(rawValue: rawValue) ?? .jobStateInProcess
            }
        }
    }
}
