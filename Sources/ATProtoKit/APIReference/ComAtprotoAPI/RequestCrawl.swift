//
//  RequestCrawl.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

extension ATProtoKit {

    /// Requests the crawling service to begin crawling the repositories.
    /// 
    /// - Note: According to the AT Protocol specifications: "Notify a crawling service of a recent
    /// update, and that crawling should resume. Intended use is after a gap between repo
    /// stream events caused the crawling service to disconnect. Does not require auth;
    /// implemented by Relay."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.notifyOfUpdate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/notifyOfUpdate.json
    ///
    /// - Parameters:
    ///   - crawlingHostname: The hostname that the crawling service resides in. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func requestCrawl(
        in crawlingHostname: String? = nil,
        pdsURL: String? = nil
    ) async throws {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.sync.notifyOfUpdate") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let hostnameURL = URL(string: crawlingHostname ?? sessionURL)

        guard let finalhostnameURL = hostnameURL else {
            throw ATRequestPrepareError.invalidHostnameURL
        }

        let requestBody = ComAtprotoLexicon.Sync.Crawler(
            crawlingHostname: finalhostnameURL
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: nil
            )

            try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
