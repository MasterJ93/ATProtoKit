//
//  AppBskyNotificationPutPreferencesV2Method.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-06-14.
//

import Foundation

extension ATProtoKit {

    /// Sets notification preferences for a user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Set notification-related preferences for
    /// an account. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.notification.putPreferencesV2`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/notification/putPreferencesV2.json
    ///
    public func putPreferencesV2(
        chat: AppBskyLexicon.Notification.ChatPreferenceDefinition? = nil,
        follow: AppBskyLexicon.Notification.FilterablePreferenceDefinition? = nil,
        like: AppBskyLexicon.Notification.FilterablePreferenceDefinition? = nil,
        likeViaRepost: AppBskyLexicon.Notification.FilterablePreferenceDefinition? = nil,
        mention: AppBskyLexicon.Notification.FilterablePreferenceDefinition? = nil,
        quote: AppBskyLexicon.Notification.FilterablePreferenceDefinition? = nil,
        reply: AppBskyLexicon.Notification.FilterablePreferenceDefinition? = nil,
        repost: AppBskyLexicon.Notification.FilterablePreferenceDefinition? = nil,
        repostViaRepost: AppBskyLexicon.Notification.FilterablePreferenceDefinition? = nil,
        starterpackjoined: AppBskyLexicon.Notification.PreferenceDefinition? = nil,
        subscribedPost: AppBskyLexicon.Notification.PreferenceDefinition? = nil,
        unverified: AppBskyLexicon.Notification.PreferenceDefinition? = nil,
        verified: AppBskyLexicon.Notification.PreferenceDefinition? = nil
    ) async throws -> AppBskyLexicon.Notification.PutPreferencesV2Output {
        guard let session = try await self.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        let accessToken = try await keychain.retrieveAccessToken()
        let sessionURL = session.serviceEndpoint.absoluteString

        guard let requestURL = URL(string: "\(sessionURL)/xrpc/app.bsky.notification.putPreferencesV2") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = AppBskyLexicon.Notification.PutPreferencesV2RequestBody(
            chat: chat,
            follow: follow,
            like: like,
            likeViaRepost: likeViaRepost,
            mention: mention,
            quote: quote,
            reply: reply,
            repost: repost,
            repostViaRepost: repostViaRepost,
            starterPackJoined: starterpackjoined,
            subscribedPost: subscribedPost,
            unverified: unverified,
            verified: verified
        )

        do {
            let request = apiClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )
            let response = try await apiClientService.sendRequest(
                request,
                decodeTo: AppBskyLexicon.Notification.PutPreferencesV2Output.self
            )

            return response
        } catch {
            throw error
        }
    }
}
