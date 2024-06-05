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
    /// - Returns: A `Result`, containing either an
    /// ``ComAtprotoLexicon/Admin/UpdateSubjectStatusOutput``
    /// if successful, or an `Error` if not.
    public func updateSubjectStatusAsAdmin(
        _ subject: ATUnion.AdminUpdateSubjectStatusUnion,
        takedown: ComAtprotoLexicon.Admin.StatusAttributesDefinition?,
        deactivated: ComAtprotoLexicon.Admin.StatusAttributesDefinition?
    ) async throws -> Result<ComAtprotoLexicon.Admin.UpdateSubjectStatusOutput, Error> {
        guard session != nil,
              let accessToken = session?.accessToken else {
            return .failure(ATRequestPrepareError.missingActiveSession)
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.updateSubjectStatus") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = ComAtprotoLexicon.Admin.UpdateSubjectStatusRequestBody(
            subject: subject,
            takedown: takedown,
            deactivated: deactivated
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: ComAtprotoLexicon.Admin.UpdateSubjectStatusOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
