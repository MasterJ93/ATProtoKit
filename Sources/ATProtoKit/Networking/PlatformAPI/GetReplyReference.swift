//
//  GetReplyReference.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-29.
//

import Foundation

extension ATProtoKit {
    /// Resolves the reply references to prepare them for a later post record request.
    ///
    /// - Parameter parentURI: The URI of the post record the current one is directly replying to.
    /// - Returns: A ``ReplyReference``.
    public static func resolveReplyReferences(parentURI: String) async throws -> ReplyReference {
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
    public static func fetchRecordForURI(_ uri: String) async throws -> RecordOutput {
        let query = try parseURI(uri)

        let record = try await getRepoRecord(from: query)

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
    private static func createReplyReference(from record: RecordOutput) -> ReplyReference {
        let reference = StrongReference(recordURI: record.recordURI, cidHash: record.recordCID)
        return ReplyReference(root: reference, parent: reference)
    }
    
    /// Parses the URI in order to get a ``RecordQuery``.
    ///
    /// There are two formats of URIs: the ones that have the `at://` protocol, and the ones that start off with the URL of the Personal Data Server (PDS). Regardless of option, this method should be able to parse
    /// them and return a proper ``RecordQuery``. However, it's still important to validate the record by using ``getRepoRecord(from:pdsURL:)``.
    /// - Parameters:
    ///   - uri: The URI to parse.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    /// - Returns: A ``RecordQuery``.
    internal static func parseURI(_ uri: String, pdsURL: String = "https://bsky.app") throws -> RecordQuery {
        if uri.hasPrefix("at://") {
            let components = uri.split(separator: "/").map(String.init)
            guard components.count >= 4 else { throw URIError.invalidFormat }

            return RecordQuery(repo: components[1], collection: components[2], recordKey: components[3])
        } else if uri.hasPrefix("\(pdsURL)/") {
            let components = uri.split(separator: "/").map(String.init)
            guard components.count >= 6 else {
                throw URIError.invalidFormat }

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
                    throw URIError.invalidFormat
            }

            return RecordQuery(repo: record, collection: collection, recordKey: recordKey)
        } else {
            throw URIError.invalidFormat
        }
    }

    enum URIError: Error {
        case invalidFormat
    }
}
