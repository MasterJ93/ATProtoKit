//
//  ToolsOzoneModerationGetSubjects.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-03-31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Moderation {

    /// An output model for retrieving the details of subjects.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about subjects."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.moderation.getSubjects`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/moderation/getSubjects.json
    public struct GetSubjectsOutput: Sendable, Codable {

        /// An array of the subject's details.
        public let subjects: [ToolsOzoneLexicon.Moderation.SubjectViewDefinition]
    }
}
