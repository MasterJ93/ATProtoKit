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
class ATProtoTools {
    /// Resolves the reply references to prepare them for a later post record request.
    ///
    /// - Parameter parentURI: The URI of the post record the current one is directly replying to.
    /// - Returns: A ``ReplyReference``.
    public func resolveReplyReferences(parentURI: String) async throws -> ReplyReference {
        let parentRecord = try await fetchRecordForURI(parentURI)

        guard let replyReference = parentRecord.value?.reply else {
            // The parent record is a top-level post, so it is also the root
            return createReplyReference(from: parentRecord)
        }

        let rootRecord = try await fetchRecordForURI(replyReference.root.recordURI)
        let rootReference = rootRecord.value?.reply?.root ?? replyReference.root

        return ReplyReference(root: rootReference, parent: replyReference.parent)
    }

    /// Gets a record from the user's repository.
    ///
    /// - Parameter uri: The URI of the record.
    /// - Returns: A ``RecordOutput``
    public func fetchRecordForURI(_ uri: String) async throws -> RecordOutput {
        let query = try parseURI(uri)

        let record = try await ATProtoKit().getRepositoryRecord(from: query, pdsURL: nil)

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
    private func createReplyReference(from record: RecordOutput) -> ReplyReference {
        let reference = StrongReference(recordURI: record.recordURI, cidHash: record.recordCID)
        return ReplyReference(root: reference, parent: reference)
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

            return RecordQuery(repo: components[1], collection: components[2], recordKey: components[3])
        } else if uri.hasPrefix("\(pdsURL)/") {
            let components = uri.split(separator: "/").map(String.init)
            guard components.count >= 6 else {
                throw ATRequestPrepareError.invalidFormat }

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

            return RecordQuery(repo: record, collection: collection, recordKey: recordKey)
        } else {
            throw ATRequestPrepareError.invalidFormat
        }
    }
}
