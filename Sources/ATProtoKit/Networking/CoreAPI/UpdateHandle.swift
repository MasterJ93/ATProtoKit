//
//  UpdateHandle.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    /// Replaces the user's current handle with a new one.
    ///
    /// - Note: According to the AT Protocol specifications: "Updates the current account's handle. Verifies handle validity, and updates did:plc document if necessary. Implemented by PDS, and requires auth."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.identity.updateHandle`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/updateHandle.json
    ///
    /// - Parameter handle: The object which conains the user's new handle.
    public func updateHandle(_ handle: UpdateHandleQuery) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.identity.updateHandle") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(accessToken)")

            try await APIClientService.sendRequest(request,
                                                   withEncodingBody: handle)
        } catch {
            throw error
        }
    }
}
