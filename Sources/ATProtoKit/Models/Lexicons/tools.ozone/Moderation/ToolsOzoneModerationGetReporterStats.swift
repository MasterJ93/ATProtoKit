//
//  ToolsOzoneModeratorGetReporterStats.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Moderation {

    /// An output model for retrieving statistics about reporters for a list of users.
    ///
    /// - Note: According to the AT Protocol specifications: "Get reporter stats for a list
    /// of users."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getReporterStats`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getReporterStats.json
    public struct GetReporterStatsOutput: Sendable, Codable {

        /// An array of reporter statistics.
        public let stats: [ToolsOzoneLexicon.Moderation.ReporterStatsDefinition]
    }
}
