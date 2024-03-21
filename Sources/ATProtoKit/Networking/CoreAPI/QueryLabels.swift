//
//  QueryLabels.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-16.
//

import Foundation

extension ATProtoKit {
    /// Finds relevant labels based on a given URI.
    ///
    /// `uriPatterns` will match with the boolean "OR". Each URI pattern can either have the `*` prefix or the full URI.
    ///
    /// - Note: According to the AT Protocol specifications: "Find labels relevant to the provided AT-URI patterns. Public endpoint for moderation services, though may return different or additional results with auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.label.queryLabels`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/queryLabels.json
    ///
    /// - Parameters:
    ///   - uriPatterns: An array of URI patterns.
    ///   - sources: An array of decentralized identifiers (DIDs) for label sources. Optional.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to `50`. Can only choose between `1` and `250`.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///   - shouldAuthenticate: Indicates whether the method will use the access token when sending the request. Defaults to `false`.
    /// - Returns: A `Result`, containing either a ``LabelQueryLabelOutput`` if successful, or an `Error` if not.
    public func queryLabels(uriPatterns: [String], sources: [String]?, limit: Int? = 50, cursor: String? = nil,
                            pdsURL: String? = nil,
                            shouldAuthenticate: Bool = false) async throws -> Result<LabelQueryLabelsOutput, Error> {
        var accessToken: String? = nil

        if shouldAuthenticate == true {
            guard session != nil,
                  accessToken == session?.accessToken else {
                throw ATRequestPrepareError.missingActiveSession
            }
        }

        guard let sessionURL = pdsURL != nil ? pdsURL : session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.label.queryLabels") else {
            throw ATRequestPrepareError.missingActiveSession
        }

        var queryItems = [(String, String)]()

        queryItems += uriPatterns.map { ("uriPatterns", $0) }

        if let sources {
            queryItems += sources.map { ("sources", $0) }
        }

        if let limit {
            let finalLimit = min(1, max(limit, 250))
            queryItems.append(("limit", "\(finalLimit)"))
        }

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: accessToken)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: LabelQueryLabelsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
