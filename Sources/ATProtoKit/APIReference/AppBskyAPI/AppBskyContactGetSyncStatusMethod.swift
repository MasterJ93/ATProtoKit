//
//  AppBskyContactGetSyncStatusMethod.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Gets the user's current contact import sync status.
    ///
    /// - Note: According to the AT Protocol specifications: "Gets the user's current contact
    /// import status. Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.getSyncStatus`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/getSyncStatus.json
    ///
    /// - Returns: A ``AppBskyLexicon/Contact/GetSyncStatusOutput`` containing the current sync
    /// status, or `nil` in `syncStatus` if the user has never imported contacts.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func getSyncStatus() async throws -> AppBskyLexicon.Contact.GetSyncStatusOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.contact.getSyncStatus") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                requiresAuthorization: true
            )

            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Contact.GetSyncStatusOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
