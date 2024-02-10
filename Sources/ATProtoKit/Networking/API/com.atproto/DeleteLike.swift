//
//  DeleteLike.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-10.
//

import Foundation

extension ATProtoKit {
    public func deleteLikeRecord(_ record: RecordIdentifier) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.deleteRecord") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var likeRecord: RecordQuery? = nil
        switch record {
            case .recordQuery(let recordQuery):
                do {
                    let output = try await ATProtoKit.fetchRecord(fromRecordQuery: recordQuery)

                    // Perform the fetch and validation based on recordQuery.
                    let recordURI = "at://\(recordQuery.repo)/\(recordQuery.collection)/\(recordQuery.recordKey)"
                    guard output.atURI == recordURI else {
                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Record"])
                    }

                    likeRecord = recordQuery
                } catch {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Record"])
                }
            case .atURI(let atURI):
                do {
                    // Perform the fetch and validation based on the parsed URI.
                    let parsedURI = try ATProtoKit.parseURI(atURI)
                    let output = try await ATProtoKit.fetchRecord(fromRecordQuery: parsedURI)

                    guard atURI == output.atURI else {
                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Record"])
                    }

                    likeRecord = parsedURI
                } catch {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Record"])
                }
        }

        let requestBody = likeRecord

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, authorizationValue: "Bearer \(session.accessToken)")

        do {
            try await APIClientService.sendRequest(request, withEncodingBody: requestBody)
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(error)"])
        }
    }

    public enum RecordIdentifier {
        case recordQuery(recordQuery: RecordQuery)
        case atURI(atURI: String)
    }
}
