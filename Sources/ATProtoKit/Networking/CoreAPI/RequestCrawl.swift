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
    /// - Parameters:
    ///   - crawlingHostname: The hostname that the crawling service resides in. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    public func requestCrawl(in crawlingHostname: String? = nil,
                             pdsURL: String? = nil) async throws {
        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.graph.notifyOfUpdate") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        var hostnameURL = URL(string: crawlingHostname ?? sessionURL)

        guard let finalhostnameURL = hostnameURL else {
            throw ATRequestPrepareError.invalidHostnameURL
        }

        let requestBody = SyncCrawler(
            crawlingHostname: finalhostnameURL
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: nil)

            try await APIClientService.sendRequest(request,
                                                   withEncodingBody: requestBody)
        } catch {
            throw error
        }
    }
}
