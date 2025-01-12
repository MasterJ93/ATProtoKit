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
        let mirror = Mirror(reflecting: self)

        guard let uriProperty = mirror.children.first(where: { $0.label == "feedURI" })?.value as? String else {
            return ""
        }

        return uriProperty
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
