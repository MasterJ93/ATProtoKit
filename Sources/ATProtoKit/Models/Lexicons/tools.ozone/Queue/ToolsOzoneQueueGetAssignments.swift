//
//  ToolsOzoneQueueGetAssignments.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Queue {

    /// An output model for getting moderator assignments for queues.
    ///
    /// - Note: According to the AT Protocol specifications: "Get moderator assignments, optionally
    /// filtered by active status, queue, or moderator."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.getAssignments`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/getAssignments.json
    public struct GetAssignmentsOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of queue moderator assignments.
        public let assignments: [QueueAssignmentViewDefinition]
    }
}
