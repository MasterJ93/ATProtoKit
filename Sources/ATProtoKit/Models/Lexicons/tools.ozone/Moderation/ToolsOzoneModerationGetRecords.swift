//
//  ToolsOzoneModerationGetRecords.swift
//
//  Created by Christopher Jr Riley on 2024-10-06.
//

import Foundation
import ATMacro

extension ToolsOzoneLexicon.Moderation {

    /// An output model for getting records as a moderator.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about some records."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getRecords`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getRecords.json
    public struct GetRecordsOutput: Sendable, Codable {

        /// An array of records that belong to the
        public var records: [String]
    }
}

extension ATUnion {
    #ATUnionBuilder(named: "ModerationGetRecordsOutputUnion", containing: [
        "recordViewDetail" : "ToolsOzoneLexicon.Moderation.RecordViewDetailDefinition",
        "recordViewNotFound" : "ToolsOzoneLexicon.Moderation.RecordViewNotFoundDefinition"
    ])
}
