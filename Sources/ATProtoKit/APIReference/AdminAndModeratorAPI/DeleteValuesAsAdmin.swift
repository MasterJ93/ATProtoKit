//
//  DeleteValuesAsAdmin.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ATProtoAdmin {

    /// Deletes values of a set as a moderator.
    /// 
    /// - Note: According to the AT Protocol specifications: "Delete values from a specific set.
    /// Attempting to delete values that are not in the set will not result in an error."
    /// 
    /// - SeeAlso: This is based on the [`tools.ozone.set.deleteValues`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/set/deleteValues.json
    /// 
    /// - Parameters:
    ///   - name: The name of the set.
    ///   - values: An array of values to delete.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func deleteValues(from name: String, matching values: [String]) async throws {
        guard session != nil,
              let accessToken = session?.accessToken else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/tools.ozone.set.deleteValues") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ToolsOzoneLexicon.Set.DeleteValuesRequestBody(
            name: name,
            values: values
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .get,
                acceptValue: "application/json",
                contentTypeValue: nil,
                authorizationValue: "Bearer \(accessToken)"
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ToolsOzoneLexicon.Set.DeleteSetOutput.self
            )
        } catch {
            throw error
        }
    }
}
