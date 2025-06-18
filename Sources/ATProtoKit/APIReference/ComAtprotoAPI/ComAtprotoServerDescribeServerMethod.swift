//
//  ComAtprotoServerDescribeServerMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Describes the server instance in the AT Protocol.
    /// 
    /// - Note: According to the AT Protocol specifications: "Describes the server's account
    /// creation requirements and capabilities. Implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.describeServer`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/describeServer.json
    ///
    /// - Returns: Some general information of the server that matches with either
    /// ``ATProtoKit/ATProtoKit/pdsURL`` or `session.pdsURL`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func describeServer() async throws -> ComAtprotoLexicon.Server.DescribeServerOutput {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.describeServer") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: ComAtprotoLexicon.Server.DescribeServerOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
