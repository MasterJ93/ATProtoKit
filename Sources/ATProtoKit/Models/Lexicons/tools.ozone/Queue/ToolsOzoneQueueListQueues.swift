//
//  ToolsOzoneQueueListQueues.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-08-13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Queue {

    /// An output model for listing all configured moderation queues.
    ///
    /// - Note: According to the AT Protocol specifications: "List all configured moderation
    /// queues with statistics."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.queue.listQueues`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/queue/listQueues.json
    public struct ListQueuesOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of moderation queues.
        public let queues: [QueueViewDefinition]
    }
}
