//
//  NotifyOfUpdate.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

extension ATProtoKit {
    /// Notifies the crawling service to re-index or resume crawling.
    /// 
    /// - Note: If `crawlingHostname` and `pdsURL` are the same, then it's best not to give a value to `hostname`.
    ///
    /// - Parameters:
    ///   - crawlingHostname: The hostname that the crawling service resides in. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    public static func notifyOfUpdate(in crawlingHostname: URL? = nil, pdsURL: String = "https://bsky.social") async throws {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/app.bsky.graph.notifyOfUpdate") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        // Check if the `crawlingHostname` and `pdsURL` are the same.
        // If so, then default the variable to `pdsURL`.
        guard let finalHostName = crawlingHostname ?? URL(string: pdsURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Hostname"])
        }

        let requestBody = SyncCrawler(
            crawlingHostname: finalHostName
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: nil)

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
