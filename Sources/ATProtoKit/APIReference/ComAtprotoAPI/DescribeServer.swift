//
//  DescribeServer.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-25.
//

import Foundation

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
    /// - Parameter pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: Some general information of the server that matches with either `pdsURL`
    /// or `session.pdsURL`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func describeServer(_ pdsURL: String? = nil) async throws -> ComAtprotoLexicon.Server.DescribeServerOutput {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.describeServer") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ComAtprotoLexicon.Server.DescribeServerOutput.self)

            return response
        } catch {
            throw error
        }
    }
}
