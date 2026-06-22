//
//  AppBskyDraftUpdateDraftMethod.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-06-21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Updates an existing draft on the user's account.
    ///
    /// - Note: According to the AT Protocol specifications: "Updates a draft using private storage (stash). If the draft ID points to a non-existing ID, the update will be silently ignored. This is done because updates don't enforce draft limit, so it accepts all writes, but will ignore invalid ones.
    /// Requires authentication."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.draft.updateDraft`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/draft/updateDraft.json
    ///
    /// - Parameters:
    ///   - id: The TID identifier of the draft to update.
    ///   - draft: The new contents of the draft.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateDraft(
        id: String,
        with draft: AppBskyLexicon.Draft.DraftDefinition
    ) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        try await sessionConfiguration?.ensureValidToken()
        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.draft.updateDraft") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Draft.UpdateDraftRequestBody(
            draft: AppBskyLexicon.Draft.DraftWithIdDefinition(tid: id, draft: draft)
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)"
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
