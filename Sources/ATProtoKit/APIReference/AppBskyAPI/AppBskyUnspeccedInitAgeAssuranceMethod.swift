//
//  AppBskyUnspeccedInitAgeAssuranceMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-15.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Starts the age assurance process for the user account.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Initiate age assurance for an account. This is
    /// a one-time action that will start the process of verifying the user's age."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.initAgeAssurance`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/initAgeAssurance.json
    ///
    /// - Parameters:
    ///   - email: The email address used to begin the age assurance process.
    ///   - language: The preferred language of the user account for the age assurance process.
    ///   - countryCode: The user account's current location during the start of the age assurance process.
    /// - Returns: The current state of the age assurance process.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func initAgeAssurance(
        email: String,
        language: Locale,
        countryCode: Locale
    ) async throws -> AppBskyLexicon.Unspecced.AgeAssuranceStateDefinition {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.initAgeAssurance") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Unspecced.InitAgeAssuranceRequestBody(
            email: email,
            language: language,
            countryCode: countryCode
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: AppBskyLexicon.Unspecced.AgeAssuranceStateDefinition.self
            )

            return response
        } catch {
            throw error
        }
    }
}
