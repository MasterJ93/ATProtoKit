//
//  ToolsOzoneTeamDeleteMember.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Team {

    /// A request body model for deleting a member.
    ///
    /// - Note: According to the AT Protocol specifications: "Delete a member from ozone team.
    /// Requires admin role."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.team.deleteMember`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/deleteMember.json
    public struct DeleteMemberRequestBody: Sendable, Codable {

        /// The decentralized identifier (DID) of the member.
        public let memberDID: String

        enum CodingKeys: String, CodingKey {
            case memberDID = "did"
        }
    }
}
