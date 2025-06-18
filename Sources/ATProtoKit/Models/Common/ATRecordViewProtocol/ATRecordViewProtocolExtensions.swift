//
//  ATRecordViewProtocolExtensions.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-12.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Feed.PostViewDefinition: ATRecordViewProtocol {

    public func refresh(with atProtoKitInstance: ATProtoKit) async throws -> AppBskyLexicon.Feed.PostViewDefinition {
        let record = try await atProtoKitInstance.getPosts([self.uri])

        return record.posts[0]
    }
}

extension AppBskyLexicon.Feed.GeneratorViewDefinition: ATRecordViewProtocol {

    public var id: String {
        return self.feedURI
    }

    public func refresh(with atProtoKitInstance: ATProtoKit) async throws -> AppBskyLexicon.Feed.GeneratorViewDefinition {
        let record = try await atProtoKitInstance.getFeedGenerator(by: self.feedURI)

        return record.view
    }
}

extension AppBskyLexicon.Graph.ListViewDefinition: ATRecordViewProtocol {

    public func refresh(with atProtoKitInstance: ATProtoKit) async throws -> AppBskyLexicon.Graph.ListViewDefinition {
        let record = try await atProtoKitInstance.getList(from: self.uri)

        return record.list
    }
}

extension AppBskyLexicon.Graph.StarterPackViewDefinition: ATRecordViewProtocol {

    public func refresh(with atProtoKitInstance: ATProtoKit) async throws -> AppBskyLexicon.Graph.StarterPackViewDefinition {
        let record = try await atProtoKitInstance.getStarterPack(uri: self.uri)

        return record.starterPack
    }
}

// MARK: Identifiable-only Extensions -
extension AppBskyLexicon.Feed.FeedViewPostDefinition: Identifiable {

    public var id: String {
        return self.post.uri
    }

    /// Refreshes the record view with updated information.
    ///  
    /// You need to pass in the instance of ``SessionConfiguration`` in order to establish
    /// a connection. Once that happens, use the appropriate method to get the record view.
    /// For example, for ``AppBskyLexicon/Feed/PostViewDefinition``, you can use
    /// ``ATProtoKit/ATProtoKit/getPosts(_:)``, which returns that object.
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - atProtoKitConfiguration: An instance of ``ATProtoKit/ATProtoKit``.
    ///   - array: The array of the
    ///   - index: The index number
    ///   - feedURI: The URI of the feed.
    /// - Returns: An updated version of the feed's array.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func refresh(
        with atProtoKitConfiguration: ATProtoKit,
        from array: [AppBskyLexicon.Feed.FeedViewPostDefinition],
        at index: Int,
        feedURI: String
    ) async throws -> [AppBskyLexicon.Feed.FeedViewPostDefinition] {
        let post = try await atProtoKitConfiguration.getFeed(by: feedURI).feed[index]

        if index > 99 {
            throw FeedViewPostDefinitionError.indexTooHigh(index: index)
        }

        var newArray = array
        newArray[index] = post
        return newArray
    }
}

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

extension AppBskyLexicon.Labeler.LabelerViewDefinition: Identifiable {
    public var id: String {
        return self.uri
    }
}

extension AppBskyLexicon.Graph.StarterPackViewBasicDefinition: Identifiable {
    public var id: String {
        return self.uri
    }
}

extension AppBskyLexicon.Embed.RecordDefinition.ViewRecord.EmbedsUnion: Identifiable {
    public var id: String {
        switch self {
            case .embedExternalView(let view):
                return view.id
            case .embedImagesView(let view):
                return view.id
            case .embedRecordView(let view):
                return view.id
            case .embedRecordWithMediaView(let view):
                return view.id
            case .embedVideoView(let view):
                return view.id
            case .unknown(_, let dictionary):
                return String(dictionary.hashValue)
        }
    }
}

extension AppBskyLexicon.Embed.ExternalDefinition.View: Identifiable {
    public var id: String {
        return "\(self.external.uri)"
    }
}

extension AppBskyLexicon.Embed.ImagesDefinition.View: Identifiable {
    public var id: String {
        return images.map(\.id).joined(separator: "_")
    }
}

extension AppBskyLexicon.Embed.ImagesDefinition.ViewImage: Identifiable {
    public var id: String {
        return "\(self.fullSizeImageURL)_\(self.thumbnailImageURL)"
    }
}

extension AppBskyLexicon.Embed.RecordDefinition.View: Identifiable {
    public var id: String {
        switch self.record {
            case .viewRecord(let viewRecord):
                return viewRecord.id
            case .viewNotFound(let viewNotFound):
                return viewNotFound.id
            case .viewBlocked(let viewBlocked):
                return viewBlocked.id
            case .viewDetached(let viewDetached):
                return viewDetached.id
            case .generatorView(let generatorView):
                return generatorView.id
            case .listView(let listView):
                return listView.id
            case .labelerView(let labelerView):
                return labelerView.id
            case .starterPackViewBasic(let starterPackViewBasic):
                return starterPackViewBasic.id
            case .unknown(_, let dictionary):
                return String(dictionary.hashValue)
        }
    }
}

extension AppBskyLexicon.Embed.RecordDefinition.ViewRecord: Identifiable {
    public var id: String {
        return self.uri
    }
}

extension AppBskyLexicon.Embed.RecordDefinition.ViewNotFound: Identifiable {
    public var id: String {
        return self.uri
    }
}

extension AppBskyLexicon.Embed.RecordDefinition.ViewBlocked: Identifiable {
    public var id: String {
        return self.uri
    }
}

extension AppBskyLexicon.Embed.RecordDefinition.ViewDetached: Identifiable {
    public var id: String {
        return self.postURI
    }
}

extension AppBskyLexicon.Embed.RecordWithMediaDefinition.View: Identifiable {
    public var id: String {
        let record = self.record.id
        var media = ""

        switch self.media {
            case .embedExternalView(let mediaView):
                media = mediaView.id
            case .embedImagesView(let mediaView):
                return mediaView.id
            case .embedVideoView(let mediaView):
                return mediaView.id
            case .unknown(_, let dictionary):
                return String(dictionary.hashValue)
        }

        return "\(record)_\(media)"
    }
}

extension AppBskyLexicon.Embed.VideoDefinition.View: Identifiable {
    public var id: String {
        return self.cid
    }
}
