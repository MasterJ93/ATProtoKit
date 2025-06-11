//
//  UpdateSubjectStatusAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-03.
//

import Foundation

extension ATProtoAdmin {

    /// Updates a subject status of an account, record, or blob.
    ///  
    /// - Important: This is an administrator task and as such, regular users won't be able to
    /// access this; if they attempt to do so, an error will occur.
    /// 
    /// - Note: According to the AT Protocol specifications: "Update the service-specific admin
    /// status of a subject (account, record, or blob)."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.admin.updateSubjectStatus`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/admin/updateSubjectStatus.json
    /// 
    /// - Parameters:
    ///   - subject: The subject associated with the subject status.
    ///   - takedown: The attributes of the user account's takedown. Optional.
    ///   - deactivated: The attributes of the user account's deactivation. Optional.
    /// - Returns: The recently-updated status of a subject.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateSubjectStatus(
        _ subject: ComAtprotoLexicon.Admin.UpdateSubjectStatusRequestBody.SubjectUnion,
        takedown: ComAtprotoLexicon.Admin.StatusAttributesDefinition? = nil,
        deactivated: ComAtprotoLexicon.Admin.StatusAttributesDefinition? = nil
    ) async throws -> ComAtprotoLexicon.Admin.UpdateSubjectStatusOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()

        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.updateSubjectStatus") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Admin.UpdateSubjectStatusRequestBody(
            subject: subject,
            takedown: takedown,
            deactivated: deactivated
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ComAtprotoLexicon.Admin.UpdateSubjectStatusOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
