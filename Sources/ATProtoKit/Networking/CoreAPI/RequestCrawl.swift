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
    public static func requestCrawl(in crawlingHostname: URL? = nil, pdsURL: String = "https://bsky.social") async throws {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/app.bsky.graph.notifyOfUpdate") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        // Check if the `crawlingHostname` and `pdsURL` are the same.
        // If so, then default the variable to `pdsURL`.
        guard let finalHostName = crawlingHostname ?? URL(string: pdsURL) else {
            throw ATRequestPrepareError.invalidHostnameURL
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
