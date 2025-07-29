//
//  UpdateMemberAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-29.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    /// - Parameters:
    ///   - did: The decentralized identifier (DID) of the member.
    ///   - isDisabled: Indicates whether the member is disabled. Optional.
    ///   - role: The current role that was given to the member.
    /// - Returns: An updated version of the member within the ozone service.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateMember(
        with did: String,
        isDisabled: Bool? = nil,
        role: ToolsOzoneLexicon.Team.UpdateMember.Role
    ) async throws -> ToolsOzoneLexicon.Team.MemberDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.team.updateMember") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Team.UpdateMemberRequestBody(
            memberDID: did,
            isDisabled: isDisabled,
            role: role
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(request,
                                                                         withEncodingBody: requestBody,
                                                                         decodeTo: ToolsOzoneLexicon.Team.MemberDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
