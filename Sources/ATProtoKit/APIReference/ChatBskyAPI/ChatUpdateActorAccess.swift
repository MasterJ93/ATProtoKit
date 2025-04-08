//
//  ChatUpdateActorAccess.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-31.
//

import Foundation

extension ATProtoBlueskyChat {

    /// Updates the user account's access to direct messages as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access
    /// this; if they attempt to do so, an error will occur.
    /// 
    /// - SeeAlso: This is based on the [`chat.bsky.moderation.updateActorAccess`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/chat/bsky/moderation/updateActorAccess.json
    /// 
    /// - Parameters:
    ///   - did: The decentralized identifier (DID) of the user account.
    ///   - doesAllowAccess: Indicates whether the user account can acess direct messages.
    ///   - reference: A reference. Optional.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func updateActorAccess(
        by did: String,
        doesAllowAccess: Bool,
        reference: String? = nil
    ) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/chat.bsky.moderation.updateActorAccess") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ChatBskyLexicon.Moderation.UpdateActorAccessRequestBody(
            actorDID: did,
            doesAllowAccess: doesAllowAccess,
            reference: reference
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: nil,
                contentTypeValue: "application/json",
                authorizationValue: "Bearer \(accessToken)",
                isRelatedToBskyChat: true
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
