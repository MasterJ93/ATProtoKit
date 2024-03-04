//
//  GetRecordAsAdmin.swift
//  
//
//  Created by Christopher Jr Riley on 2024-03-01.
//

import Foundation

extension ATProtoKit {
    /// Gets details about a record as an administrator.
    /// 
    /// - Important: This is an administrator task and as such, regular users won't be able to access this; if they attempt to do so, an error will occur.
    /// 
    /// - Parameters:
    ///   - recordURI: The URI of the record.
    ///   - recordCID: The CID hash of the record. Optional.
    /// - Returns: A `Result`, containing either an ``AdminRecordViewDetail`` if successful, or an `Error` if not.
    public func getRecordAsAdmin(_ recordURI: String, recordCID: String?) async throws -> Result<AdminRecordViewDetail, Error> {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.admin.getRecord") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        var queryItems = [("uri", recordURI)]

        if let recordCID {
            queryItems.append(("cid", recordCID))
        }

        do {
            let queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: "Bearer \(session.accessToken)")
            let response = try await APIClientService.sendRequest(request, decodeTo: AdminRecordViewDetail.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
