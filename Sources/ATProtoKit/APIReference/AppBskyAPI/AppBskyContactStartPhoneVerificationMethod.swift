//
//  AppBskyContactStartPhoneVerificationMethod.swift
//  ATProtoKit
//
//  Created by KC-2001MS on 2026-08-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Starts a phone verification flow.
    ///
    /// The phone number will receive a verification code via SMS. Pass the code to
    /// ``verifyPhone(_:code:)`` to complete verification.
    ///
    /// - Note: According to the AT Protocol specifications: "Starts a phone verification flow.
    /// The phone passed will receive a code via SMS that should be passed to
    /// `app.bsky.contact.verifyPhone`. Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.contact.startPhoneVerification`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/contact/startPhoneVerification.json
    ///
    /// - Parameter phone: The phone number to receive the verification code via SMS.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func startPhoneVerification(_ phone: String) async throws {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.contact.startPhoneVerification") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Contact.StartPhoneVerificationRequestBody(
            phone: phone
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
