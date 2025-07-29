//
//  AppBskyUnspeccedCheckHandleAvailabilityMethod.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-07-23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Checks if the provided handle is available.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - Note: According to the AT Protocol specifications: "Checks whether the provided handle
    /// is available. If the handle is not available, available suggestions will be returned.
    /// Optional inputs will be used to generate suggestions."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.checkHandleAvailability`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/checkHandleAvailability.json
    ///
    /// - Parameters:
    ///   - handle: The specified handle the user wants to use.
    ///   - email: The email address of the user account. Optional.
    ///   - birthDate: The birth date of the user account. Optional.
    /// - Returns: The handle the user wants to use, followed by whether the handle is available or not.
    /// An array of suggestions are displayed if the handle is not available for use.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func checkHandleAvailability(
        handle: String,
        email: String? = nil,
        birthDate: Date? = nil
    ) async throws -> AppBskyLexicon.Unspecced.CheckHandleAvailabilityOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.unspecced.checkHandleAvailability") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var queryItems = [(String, String)]()

        queryItems.append(("handle", handle))

        if let email {
            queryItems.append(("email", email))
        }

        if let birthDateDate = birthDate, let formattedBirthDate = CustomDateFormatter.shared.string(from: birthDateDate) {
            queryItems.append(("birthDate", formattedBirthDate))
        }

        let queryURL: URL

        do {
            queryURL = try apiClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = apiClientService.createRequest(
                forRequest: queryURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Unspecced.CheckHandleAvailabilityOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
