//
//  ToolsOzoneModerationGetRecords.swift
//
//  Created by Christopher Jr Riley on 2024-10-06.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Moderation {

    /// An output model for getting records as a moderator.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about some records."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getRecords`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getRecords.json
    public struct GetRecordsOutput: Sendable, Codable {

        /// An array of records.
        public var records: [ModerationGetRecordsOutputUnion]

        // Unions
        public enum ModerationGetRecordsOutputUnion: Codable, Sendable {

            ///
            case recordViewDetail(ToolsOzoneLexicon.Moderation.RecordViewDetailDefinition)

            ///
            case recordViewNotFound(ToolsOzoneLexicon.Moderation.RecordViewNotFoundDefinition)

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let value = try? container.decode(ToolsOzoneLexicon.Moderation.RecordViewDetailDefinition.self) {
                    self = .recordViewDetail(value)
                } else if let value = try? container.decode(ToolsOzoneLexicon.Moderation.RecordViewNotFoundDefinition.self) {
                    self = .recordViewNotFound(value)
                } else {
                    throw DecodingError.typeMismatch(
                        ModerationGetRecordsOutputUnion.self, DecodingError.Context(
                            codingPath: decoder.codingPath, debugDescription: "Unknown ModerationGetRecordsOutputUnion type"))
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                    case .recordViewDetail(let unionValue):
                        try container.encode(unionValue)
                    case .recordViewNotFound(let unionValue):
                        try container.encode(unionValue)
                }
            }
        }
    }
}
