//
//  ReserveSigningKey.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

extension ATProtoKit {

    /// Reserves a signing key for the respository.
    /// 
    /// - Note: According to the AT Protocol specifications: "Reserve a repo signing key, for use
    /// with account creation. Necessary so that a DID PLC update operation can be constructed
    /// during an account migraiton. Public and does not require auth; implemented by PDS.
    /// NOTE: this endpoint may change when full account migration is implemented."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.reserveSigningKey`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/reserveSigningKey.json
    ///
    /// - Parameters:
    ///   - repositoryDID: The decentalized identifier (DID) of the repository.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://api.bsky.app`.
    /// - Returns: The newly-created signing key.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func reserveSigningKey(
        for repositoryDID: String,
        pdsURL: String = "https://api.bsky.app"
    ) async throws -> ComAtprotoLexicon.Server.ReserveSigningKeyOutput {
        let finalPDSURL = self.determinePDSURL(customPDSURL: pdsURL)

        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/com.atproto.server.reserveSigningKey") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Server.ReserveSigningKeyRequestBody(
            repositoryDID: repositoryDID
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ComAtprotoLexicon.Server.ReserveSigningKeyOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
