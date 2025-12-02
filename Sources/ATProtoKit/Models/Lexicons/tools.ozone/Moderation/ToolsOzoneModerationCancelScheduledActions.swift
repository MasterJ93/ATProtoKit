//
//  ToolsOzoneModerationCancelScheduledActions.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-11-18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Moderation {

    /// A definition model for cancelling any pending scheduled moderation actions for the specified
    /// user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Cancel all pending scheduled moderation actions for specified subjects"
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.cancelScheduledActions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/cancelScheduledActions.json
    public struct CancelScheduledActions: Sendable, Codable {

        /// Results of the cancelled pending actions.
        public struct CancellationResults: Sendable, Codable {

            /// An array of decentralized identifiers (DIDs) that had all of their actions
            /// successfully completed.
            ///
            /// - Note: According to the AT Protocol specifications: "DIDs for which all pending scheduled
            /// actions were successfully cancelled."
            public let successfulActions: [String]

            /// An array of error details for each failed action.
            ///
            /// - Note: According to the AT Protocol specifications: "DIDs for which cancellation failed
            /// with error details."
            public let failedActions: [FailedCancellation]

            enum CodingKeys: String, CodingKey {
                case successfulActions = "succeeded"
                case failedActions = "failed"
            }
        }

        /// Error details for each failed action.
        public struct FailedCancellation: Sendable, Codable {

            /// The decentralized identifier (DID) of the user account associated with the failed action.
            public let did: String

            /// The error details.
            public let error: String

            /// The error code of the failed action. Optional.
            public let errorCode: String?
        }
    }

    /// A request body model for cancelling any pending scheduled moderation actions for the specified
    /// user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Cancel all pending scheduled moderation actions for specified subjects"
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.cancelScheduledActions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/cancelScheduledActions.json
    public struct CancelScheduledActionsRequestBody: Sendable, Codable {

        /// An array of decentralized identifiers (DIDs) for which the cancellations will occur on.
        ///
        /// - Note: According to the AT Protocol specifications: "Array of DID subjects to cancel scheduled
        /// actions for."
        public let subjects: [String]

        /// A comment to attach to the cancellation. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Optional comment describing the reason
        /// for cancellation."
        public let comment: String?

        public init(subjects: [String], comment: String?) {
            self.subjects = subjects
            self.comment = comment
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.subjects = try container.decode([String].self, forKey: .subjects)
            self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.truncatedEncode(self.subjects, forKey: .subjects, upToArrayLength: 100)
            try container.encodeIfPresent(self.comment, forKey: .comment)
        }

        enum CodingKeys: CodingKey {
            case subjects
            case comment
        }
    }

//    /// An output model for cancelling any pending scheduled moderation actions for the specified
//    /// user accounts.
//    ///
//    /// - Note: According to the AT Protocol specifications: "Cancel all pending scheduled moderation actions for specified subjects"
//    ///
//    /// - SeeAlso: This is based on the [`tools.ozone.moderation.cancelScheduledActions`][github] lexicon.
//    ///
//    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/cancelScheduledActions.json
//    public struct CancelScheduledActionsOutput: Sendable, Codable {
//
//        ///
//    }
}
