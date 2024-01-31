//
//  GetReplyReference.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-29.
//

import Foundation

extension ATProtoKit {

    public func resolveReplyReferences(parentURI: String) async throws -> ReplyReference {
        // Parse the parent URI and fetch the parent record
        let parentQuery = try ATProtoKit.parseURI(parentURI)

        // Fetch the parent record using the RecordQuery object
        let parentRecord = try await ATProtoKit.fetchRecord(fromRecordQuery: parentQuery)

        // Access the reply property from the RecordValueReply within RecordOutput
        if let replyReference = parentRecord.value?.reply {
            // Parse the root URI to get a RecordQuery object
            let rootQuery = try ATProtoKit.parseURI(replyReference.root.recordURI)

            // Fetch the root record using the RecordQuery object
            let rootRecord = try await ATProtoKit.fetchRecord(fromRecordQuery: rootQuery)

            // Use the StrongReference directly since they match the required structure
            return ReplyReference(root: rootRecord.value?.reply.root ?? replyReference.root,
                                  parent: replyReference.parent)
        } else {
            // The parent record is a top-level post, so it is also the root
            let ref = StrongReference(recordURI: parentRecord.atURI, cidHash: parentRecord.recordCID)
            return ReplyReference(root: ref, parent: ref)
        }
    }

    public static func fetchRecord(fromRecordQuery recordQuery: RecordQuery, pdsURL: String = "https://bsky.social") async throws -> RecordOutput {

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

    public static func parseURI(_ uri: String) throws -> RecordQuery {
        if uri.hasPrefix("at://") {
            let components = uri.split(separator: "/").map(String.init)
            guard components.count >= 4 else { throw URIError.invalidFormat }

            return RecordQuery(repo: components[1], collection: components[2], recordKey: components[4], recordCID: nil)
        } else if uri.hasPrefix("https://bsky.app/") {
            let components = uri.split(separator: "/").map(String.init)
            print("Components: \(components[3]), \(components[4]), \(components[5])")
            print("Components: \(components)")
            guard components.count >= 6 else {
                print("Components aren't less than 8.")
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

            return RecordQuery(repo: record, collection: collection, recordKey: recordKey, recordCID: nil)
        } else {
            throw URIError.invalidFormat
        }
    }

    enum URIError: Error {
        case invalidFormat
    }
}
