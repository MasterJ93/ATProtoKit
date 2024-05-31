//
//  ATProtoTools.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-29.
//

import Foundation

/// A group of methods for miscellaneous aspects of ATProtoKit.
///
/// These methods are useful for anything that's too small or too niche to be added elsewhere.
/// This may also include methods directly related to the AT Protocol.
///
/// If a method is better suited elsewhere, then it will be re-created to a more appropriate
/// `class`. The version in here will then become deprecated, and then later removed in a
/// future update.
///
/// - Important: The rule where the method becomes deprecated will be active either
/// when version 1.0 is launched or `ATProtoTools` is stabilized, whichever comes first.
/// Until then, if a method is better suited elsewhere, it will be immediately moved.
public class ATProtoTools {

    /// Resolves the reply references to prepare them for a later post record request.
    ///
    /// - Parameter parentURI: The URI of the post record the current one is directly replying to.
    /// - Returns: A ``ReplyReference``.
    public func resolveReplyReferences(parentURI: String) async throws -> AppBskyLexicon.Feed.PostRecord.ReplyReference {
        let threadRecords = try await fetchRecordForURI(parentURI)

        guard let parentRecord = threadRecords.value else {
            return createReplyReference(from: threadRecords)
        }

        var replyReference: AppBskyLexicon.Feed.PostRecord.ReplyReference?

        switch parentRecord {
            case .unknown(let unknown):
                replyReference = try decodeReplyReference(from: unknown)
            default:
                break
        }

        if let replyReference = replyReference {
            return try await getReplyReferenceWithRoot(replyReference)
        }

        return createReplyReference(from: threadRecords)
    }

    private func decodeReplyReference(from unknown: [String: Any]) throws -> AppBskyLexicon.Feed.PostRecord.ReplyReference? {
        if let replyData = unknown["reply"] as? [String: Any] {
            let jsonData = try JSONSerialization.data(withJSONObject: replyData, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(AppBskyLexicon.Feed.PostRecord.ReplyReference.self, from: jsonData)
        }
        return nil
    }

    private func getReplyReferenceWithRoot(
        _ replyReference: AppBskyLexicon.Feed.PostRecord.ReplyReference) async throws -> AppBskyLexicon.Feed.PostRecord.ReplyReference {
        let rootRecord = try await fetchRecordForURI(replyReference.root.recordURI)

        if let rootReferenceValue = rootRecord.value {
            switch rootReferenceValue {
                case .unknown:
                    return AppBskyLexicon.Feed.PostRecord.ReplyReference(root: replyReference.root, parent: replyReference.parent)
                default:
                    return AppBskyLexicon.Feed.PostRecord.ReplyReference(root: replyReference.root, parent: replyReference.parent)
            }
        }
        return AppBskyLexicon.Feed.PostRecord.ReplyReference(root: replyReference.root, parent: replyReference.parent)
    }

    /// Gets a record from the user's repository.
    ///
    /// - Parameter uri: The URI of the record.
    /// - Returns: A ``RecordOutput``
    public func fetchRecordForURI(_ uri: String) async throws -> ComAtprotoLexicon.Repository.GetRecordOutput {
        let query = try parseURI(uri)

        let record = try await ATProtoKit().getRepositoryRecord(from: query.repository, collection: query.collection, recordKey: query.recordKey, pdsURL: nil)

        switch record {
            case .success(let result):
                return result
            case .failure(let failure):
                throw failure
        }
    }

    /// A utility method for converting a ``RecordOutput`` into a ``ReplyReference``.
    ///
    /// - Parameter record: The record to convert.
    /// - Returns: A ``ReplyReference``.
    private func createReplyReference(from record: ComAtprotoLexicon.Repository.GetRecordOutput) -> AppBskyLexicon.Feed.PostRecord.ReplyReference {
        let reference = ComAtprotoLexicon.Repository.StrongReference(recordURI: record.recordURI, cidHash: record.recordCID)

        return AppBskyLexicon.Feed.PostRecord.ReplyReference(root: reference, parent: reference)
    }

    /// Parses the URI in order to get a ``RecordQuery``.
    ///
    /// There are two formats of URIs: the ones that have the `at://` protocol, and the ones that
    /// start off with the URL of the Personal Data Server (PDS). Regardless of option, this method
    /// should be able to parse
    /// them and return a proper ``RecordQuery``. However, it's still important to validate the
    /// record by using ``ATProtoKit/ATProtoKit/getRepositoryRecord(from:pdsURL:)``.
    /// - Parameters:
    ///   - uri: The URI to parse.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A ``RecordQuery``.
    internal func parseURI(_ uri: String,
                           pdsURL: String = "https://bsky.app") throws -> RecordQuery {
        if uri.hasPrefix("at://") {
            let components = uri.split(separator: "/").map(String.init)
            guard components.count >= 4 else { throw ATRequestPrepareError.invalidFormat }

            return ATProtoTools.RecordQuery(repository: components[1], collection: components[2], recordKey: components[3])
        } else if uri.hasPrefix("\(pdsURL)/") {
            let components = uri.split(separator: "/").map(String.init)
            guard components.count >= 6 else {
                throw ATRequestPrepareError.invalidFormat
            }

            let record = components[3]
            let recordKey = components[5]
            let collection: String

            switch components[4] {
                case "post":
                    collection = "app.bsky.feed.post"
                case "lists":
                    collection = "app.bsky.graph.list"
                case "feed":
                    collection = "app.bsky.feed.generator"
                default:
                    throw ATRequestPrepareError.invalidFormat
            }

            return RecordQuery(repository: record, collection: collection, recordKey: recordKey)
        } else {
            throw ATRequestPrepareError.invalidFormat
        }
    }

    /// A structure for a record.
    public struct RecordQuery: Codable {

        /// The handle or decentralized identifier (DID) of the repo."
        ///
        /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo."
        public let repository: String

        /// The NSID of the record.
        ///
        /// - Note: According to the AT Protocol specifications: "The NSID of the record collection."
        public let collection: String

        /// The record's key.
        ///
        //// - Note: According to the AT Protocol specifications: "The Record Key."
        public let recordKey: String

        /// The CID of the version of the record. Optional. Defaults to `nil`.
        ///
        /// - Note: According to the AT Protocol specifications: "The CID of the version of the record.
        /// If not specified, then return the most recent version."
        public let recordCID: String? = nil

        public init(repository: String, collection: String, recordKey: String) {
            self.repository = repository
            self.collection = collection
            self.recordKey = recordKey
        }

        enum CodingKeys: String, CodingKey {
            case repository = "repo"
            case collection = "collection"
            case recordKey = "rkey"
            case recordCID = "cid"
        }
    }
}
