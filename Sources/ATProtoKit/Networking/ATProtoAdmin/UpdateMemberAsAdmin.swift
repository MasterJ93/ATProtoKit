//
//  UpdateMemberAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation

extension ATProtoAdmin {

    /// Updates a member in the ozone service.
    ///
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    ///
    /// - Note: According to the AT Protocol specifications: "Update a member in the ozone service.
    /// Requires admin role."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.team.updateMember`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/team/updateMember.json
    ///
    public func updateMember(
        with did: String,
        isDisabled: Bool? = nil,
        role: ToolsOzoneLexicon.Team.MemberDefinition.Role
    ) async throws -> ToolsOzoneLexicon.Team.MemberDefinition {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.team.updateMember") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Team.UpdateMemberRequestBody(
            memberDID: did,
            isDisabled: isDisabled,
            role: role
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ToolsOzoneLexicon.Team.MemberDefinition.self)

            return response
        } catch {
            throw error
        }
    }
}
