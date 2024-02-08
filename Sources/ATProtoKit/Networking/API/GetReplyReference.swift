//
//  GetReplyReference.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-29.
//

import Foundation

extension ATProtoKit {
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

    public static func fetchRecordForURI(_ uri: String) async throws -> RecordOutput {
        let query = try parseURI(uri)
        return try await fetchRecord(fromRecordQuery: query)
    }

    private static func createReplyReference(from record: RecordOutput) -> ReplyReference {
        let reference = StrongReference(recordURI: record.atURI, cidHash: record.recordCID)
        return ReplyReference(root: reference, parent: reference)
    }

    private static func fetchRecord(fromRecordQuery recordQuery: RecordQuery, pdsURL: String = "https://bsky.social") async throws -> RecordOutput {

        guard let url = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.getRecord") else {
            throw URIError.invalidFormat
        }

        // Prepare query parameters
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "repo", value: recordQuery.repo),
            URLQueryItem(name: "collection", value: recordQuery.collection),
            URLQueryItem(name: "rkey", value: recordQuery.recordKey)
        ]

        if let cid = recordQuery.recordCID {
            urlComponents?.queryItems?.append(URLQueryItem(name: "cid", value: cid))
        }

        guard let finalURL = urlComponents?.url else {
            throw URIError.invalidFormat
        }

        // Create and send the request using APIClientService
        let request = APIClientService.createRequest(forRequest: finalURL, andMethod: .get)
        let response = try await APIClientService.sendRequest(request, decodeTo: RecordOutput.self)
        return response
    }

    private static func parseURI(_ uri: String) throws -> RecordQuery {
        if uri.hasPrefix("at://") {
            let components = uri.split(separator: "/").map(String.init)
            guard components.count >= 4 else { throw URIError.invalidFormat }

            return RecordQuery(repo: components[1], collection: components[2], recordKey: components[3])
        } else if uri.hasPrefix("https://bsky.app/") {
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
