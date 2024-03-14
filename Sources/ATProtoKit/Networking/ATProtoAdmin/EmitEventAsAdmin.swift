//
//  EmitEventAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-29.
//

import Foundation

extension ATProtoAdmin {
    /// Enacts on an action against a user's account as a moderator.
    ///
    /// - Important: This is a moderator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    ///
    /// - Parameters:
    ///   - event: The type of event the moderator is taking,
    ///   - subject: The type of repository reference.
    ///   - subjectBlobCIDHashes: An array of CID hashes related to blobs for the moderator's event view. Optional.
    ///   - createdBy: The decentralized identifier (DID) of the moderator taking this action.
    /// - Returns: A `Result`, containing either an ``OzoneModerationEventView`` if successful, or an `Error` if not.
    public func emitEvent(_ event: AdminEventViewUnion, subject: RepositoryReferencesUnion, subjectBlobCIDHashes: [String]?,
                                           createdBy: String) async throws -> Result<OzoneModerationEventView, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.emitModerationEvent") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        let requestBody = AdminEmitModerationEvent(
            event: event,
            subject: subject,
            subjectBlobCIDHashes: subjectBlobCIDHashes,
            createdBy: createdBy
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: OzoneModerationEventView.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
