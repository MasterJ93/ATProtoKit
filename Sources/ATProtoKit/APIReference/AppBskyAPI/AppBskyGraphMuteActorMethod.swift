//
//  AppBskyGraphMuteActorMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-10.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Mutes a user account.
    /// 
    /// - Note: According to the AT Protocol specifications: "Creates a mute relationship for the
    /// specified account. If a mute already exists for the account, it is updated in place: the
    /// stored scope is replaced with the scope in this request. Mutes are private in Bluesky.
    /// Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.graph.muteActor`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/bsky/blob/main/lexicons/app/bsky/graph/muteActor.json
    ///
    /// - Parameters:
    ///   - actor: The decentralized identifier (DID) or handle of a user account.
    ///   - isOnlyReposts: Determines whether only the user account's reposts are muted. If neither
    ///   this nor `isOnlyQuotePosts` is `true`, the user account is fully muted. Optional.
    ///   - isOnlyQuotePosts: Determines whether only the user account's quote posts are
    ///   muted. Optional.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func muteActor(
        _ actor: String,
        isOnlyReposts: Bool? = nil,
        isOnlyQuotePosts: Bool? = nil
    ) async throws {
        guard let session = try await self.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.muteActor") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Graph.MuteActorRequestBody(
            actor: actor,
            isOnlyReposts: isOnlyReposts,
            isOnlyQuotePosts: isOnlyQuotePosts
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
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
