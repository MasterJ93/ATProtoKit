//
//  AppBskyDraftCreateDraftMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Creates a draft on the user's account.
    ///
    /// Drafts are server-synced post drafts stored in the user's private storage (stash).
    ///
    /// - Note: According to the AT Protocol specifications: "Inserts a draft using private storage (stash). An upper limit of drafts might be enforced.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.createDraft`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/createDraft.json
    ///
    /// - Parameter draft: The draft to be created.
    /// - Returns: The TID identifier assigned to the newly-created draft.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createDraft(
        _ draft: AppBskyLexicon.Draft.DraftDefinition
    ) async throws -> AppBskyLexicon.Draft.CreateDraftOutput {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.draft.createDraft") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Draft.CreateDraftRequestBody(draft: draft)

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: AppBskyLexicon.Draft.CreateDraftOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
