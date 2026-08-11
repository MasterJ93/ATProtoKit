//
//  AppBskyContactDismissMatchMethod.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Dismisses a contact match so it won't appear again.
    ///
    /// - Note: According to the AT Protocol specifications: "Removes a match that was found via
    /// contact import. It shouldn't appear again if the same contact is re-imported.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.dismissMatch`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/dismissMatch.json
    ///
    /// - Parameter subjectDID: The decentralized identifier (DID) of the matched user to dismiss.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func dismissMatch(subjectDID: String) async throws {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.contact.dismissMatch") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Contact.DismissMatchRequestBody(
            subjectDID: subjectDID
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                requiresAuthorization: true
            )

            _ = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
