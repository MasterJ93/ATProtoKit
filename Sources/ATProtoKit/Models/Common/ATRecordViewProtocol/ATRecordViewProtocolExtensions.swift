//
//  ATRecordViewProtocolExtensions.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-12.
//

import Foundation

extension AppBskyLexicon.Feed.PostViewDefinition: ATRecordViewProtocol {

    public func refresh(with session: UserSession) async throws -> AppBskyLexicon.Feed.PostViewDefinition {
        let config = ATProtocolConfiguration(userSession: session, pdsURL: session.pdsURL ?? "https://bsky.social")
        _ = try await config.getSession()

        let atProto = ATProtoKit(sessionConfiguration: config, canUseBlueskyRecords: false)
        let record = try await atProto.getPosts([self.uri])

        return record.posts[0]
    }
}

extension AppBskyLexicon.Feed.GeneratorViewDefinition: ATRecordViewProtocol {

    public var id: String {
        return self.feedURI
    }

    public func refresh(with session: UserSession) async throws -> AppBskyLexicon.Feed.GeneratorViewDefinition {
        let config = ATProtocolConfiguration(userSession: session, pdsURL: session.pdsURL ?? "https://bsky.social")
        _ = try await config.getSession()

        let atProto = ATProtoKit(sessionConfiguration: config, canUseBlueskyRecords: false)
        let record = try await atProto.getFeedGenerator(by: self.feedURI)

        return record.view
    }
}

extension AppBskyLexicon.Graph.ListViewDefinition: ATRecordViewProtocol {

    public func refresh(with session: UserSession) async throws -> AppBskyLexicon.Graph.ListViewDefinition {
        let config = ATProtocolConfiguration(userSession: session, pdsURL: session.pdsURL ?? "https://bsky.social")
        _ = try await config.getSession()

        let atProto = ATProtoKit(sessionConfiguration: config, canUseBlueskyRecords: false)
        let record = try await atProto.getList(from: self.uri)

        return record.list
    }
}

extension AppBskyLexicon.Graph.StarterPackViewDefinition: ATRecordViewProtocol {

    public func refresh(with session: UserSession) async throws -> AppBskyLexicon.Graph.StarterPackViewDefinition {
        let config = ATProtocolConfiguration(userSession: session, pdsURL: session.pdsURL ?? "https://bsky.social")
        _ = try await config.getSession()

        let atProto = ATProtoKit(sessionConfiguration: config, canUseBlueskyRecords: false)
        let record = try await atProto.getStarterPack(uri: self.uri)

        return record.starterPack
    }
}

extension AppBskyLexicon.Feed.FeedViewPostDefinition: ATRecordViewProtocol {

    public var id: String {
        return self.post.uri
    }

    public func refresh(with session: UserSession) async throws -> AppBskyLexicon.Feed.FeedViewPostDefinition {
        let config = ATProtocolConfiguration(userSession: session, pdsURL: session.pdsURL ?? "https://bsky.social")
        _ = try await config.getSession()

        let atProto = ATProtoKit(sessionConfiguration: config, canUseBlueskyRecords: false)
        let record = try await atProto.getFeed(by: self.post.uri)

        return record.feed[0]
    }
}

// MARK: Identifiable-only Extensions -
extension AppBskyLexicon.Actor.ProfileViewBasicDefinition: Identifiable {
    public var id: String {
        return "\(self.actorDID)"
    }
}

extension AppBskyLexicon.Actor.ProfileViewDefinition: Identifiable {
    public var id: String {
        return "\(self.actorDID)"
    }
}

extension AppBskyLexicon.Actor.ProfileViewDetailedDefinition: Identifiable {
    public var id: String {
        return "\(self.actorDID)"
    }
}
