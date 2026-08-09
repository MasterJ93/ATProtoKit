//
//  AppBskyContactVerifyPhoneMethod.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Verifies control over a phone number and obtains a token for contact import.
    ///
    /// - Note: According to the AT Protocol specifications: "Verifies control over a phone number
    /// with a code received via SMS and starts a contact import session.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.verifyPhone`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/verifyPhone.json
    ///
    /// - Parameters:
    ///   - phone: The phone number to verify. Should match the number passed to
    ///   ``startPhoneVerification(_:)``.
    ///   - code: The verification code received via SMS.
    /// - Returns: A ``AppBskyLexicon/Contact/VerifyPhoneOutput`` containing a JWT token for use
    /// with ``importContacts(token:contacts:)``.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func verifyPhone(_ phone: String, code: String) async throws -> AppBskyLexicon.Contact.VerifyPhoneOutput {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.contact.verifyPhone") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Contact.VerifyPhoneRequestBody(
            phone: phone,
            code: code
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
                decodeTo: AppBskyLexicon.Contact.VerifyPhoneOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
