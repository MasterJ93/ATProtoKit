//
//  ComAtprotoSyncRequestCrawlMethod.swift
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
    /// - SeeAlso: This is based on the [`com.atproto.sync.requestCrawl`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/requestCrawl.json
    ///
    /// - Parameter crawlingHostname: The hostname that the crawling service resides in. Optional.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func requestCrawl(in crawlingHostname: String? = nil) async throws {
        guard let requestURL = URL(string: "https://bsky.network/xrpc/com.atproto.sync.requestCrawl") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let hostnameURL = URL(string: crawlingHostname ?? self.pdsURL)

        guard let finalhostnameURL = hostnameURL else {
            throw ATRequestPrepareError.invalidHostnameURL
        }

        let requestBody = ComAtprotoLexicon.Sync.RequestCrawlRequestBody(
            crawlingHostname: finalhostnameURL
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: nil
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
