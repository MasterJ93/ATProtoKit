//
//  ActivateAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

extension ATProtoKit {
    /// Activates the user's account.
    /// 
    /// - Note: According to the AT Protocol specifications: "Activates a currently deactivated account. Used to finalize account migration after the account's repo is imported and identity is setup."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.server.activateAccount`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/activateAccount.json
    public func activateAccount() async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.activateAccount") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, acceptValue: nil, contentTypeValue: nil, authorizationValue: "Bearer \(session.accessToken)")

            _ = try await APIClientService.sendRequest(request)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Request"])
        }
    }
}
