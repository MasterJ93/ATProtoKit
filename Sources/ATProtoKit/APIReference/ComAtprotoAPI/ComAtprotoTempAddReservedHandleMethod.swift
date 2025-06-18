//
//  ComAtprotoTempAddReservedHandleMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Adds a reserved handle.
    ///
    /// - Important: The lexicon associated with this model may be removed at any time. This may
    /// not work.
    ///
    /// - Note: According to the AT Protocol specifications: "Add a handle to the set of
    /// reserved handles."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.temp.addReservedHandle`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/addReservedHandle.json
    /// 
    /// - Parameter handle: The handle to add.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func addReservedHandle(_ handle: String) async throws {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.temp.addReservedHandle") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Temp.AddReservedHandleRequestBody(
            handle: handle
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
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
