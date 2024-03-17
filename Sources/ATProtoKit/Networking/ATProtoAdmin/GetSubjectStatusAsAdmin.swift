//
//  GetSubjectStatusAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

extension ATProtoAdmin {
    /// Gets the status of a subject as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Parameters:
    ///   - subjectDID: The decentralized identifier (DID) of the subject.
    ///   - subjectURI: The URI of the subject.
    ///   - subjectBlobCIDHash: The CID hash of the blob for the subject.
    /// - Returns: A `Result`, containing either an ``AdminGetSubjectStatusOutput`` if successful, or an `Error` if not.
    public func getSubjectStatus(_ subjectDID: String, subjectURI: String, subjectBlobCIDHash: String) async throws -> Result<AdminGetSubjectStatusOutput, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getSubjectStatus") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let queryItems = [
            ("did", subjectDID),
            ("uri", subjectURI),
            ("blob", subjectBlobCIDHash)
        ]

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: AdminGetSubjectStatusOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
