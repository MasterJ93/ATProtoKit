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
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Note: According to the AT Protocol specifications: "Update the password for a user account as an administrator."
    /// 
    /// - Parameters:
    ///   - subject: The subject associated with the subject status.
    ///   - takedown: The status attributes of the subject. Optional.
    public func updateSubjectStatusAsAdmin(_ subject: AdminGetSubjectStatusUnion, takedown: AdminStatusAttributes?) async throws -> Result<AdminUpdateSubjectStatusOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.updateSubjectStatus") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let requestBody = AdminUpdateSubjectStatus(
            subject: subject,
            takedown: takedown
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: AdminUpdateSubjectStatusOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
