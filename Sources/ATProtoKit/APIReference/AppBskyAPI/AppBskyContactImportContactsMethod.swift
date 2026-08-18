//
//  AppBskyContactImportContactsMethod.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Imports a list of phone numbers to match with other users.
    ///
    /// - Note: According to the AT Protocol specifications: "Securely imports contacts to match
    /// with other users. Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.importContacts`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/importContacts.json
    ///
    /// - Parameters:
    ///   - token: The JWT token received from ``verifyPhone(_:code:)``.
    ///   - contacts: An array of phone numbers in E.164 format (e.g. `+12125550123`). Can
    ///   contain between 1 and 1,000 numbers.
    /// - Returns: A ``AppBskyLexicon/Contact/ImportContactsOutput`` containing matched users and
    /// their corresponding contact indexes.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func importContacts(token: String, contacts: [String]) async throws -> AppBskyLexicon.Contact.ImportContactsOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.contact.importContacts") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let finalContacts = Array(contacts.prefix(1000))

        let requestBody = AppBskyLexicon.Contact.ImportContactsRequestBody(
            token: token,
            contacts: finalContacts
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                requiresAuthorization: true
            )

            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: AppBskyLexicon.Contact.ImportContactsOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
