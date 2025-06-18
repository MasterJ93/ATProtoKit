//
//  ComAtprotoSyncNotifyOfUpdateMethod.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoKit {

    /// Notifies the crawling service to re-index or resume crawling.
    /// 
    /// If `crawlingHostname` and `pdsURL` are the same, then it's best not to give
    /// a value to `hostname`.
    ///
    /// - Note: According to the AT Protocol specifications: "Notify a crawling service of a recent
    /// update, and that crawling should resume. Intended use is after a gap between repo stream
    /// events caused the crawling service to disconnect. Does not require auth; implemented
    /// by Relay."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.sync.notifyOfUpdate`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/sync/notifyOfUpdate.json
    ///
    /// - Parameters:
    ///   - crawlingHostname: The hostname that the crawling service resides in. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://api.bsky.app`.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    @available(*, deprecated, renamed: "requestCrawl", message: "Use requestCrawl() instead")
    public func notifyOfUpdate(
        in crawlingHostname: URL,
        pdsURL: String = "https://api.bsky.app"
    ) async throws {
        guard let requestURL = URL(string: "https://bsky.network/xrpc/com.atproto.sync.notifyOfUpdate") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Sync.NotifyOfUpdateRequestBody(
            crawlingHostname: crawlingHostname
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
