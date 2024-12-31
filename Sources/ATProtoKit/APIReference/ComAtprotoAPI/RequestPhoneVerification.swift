//
//  RequestPhoneVerification.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

extension ATProtoKit {

    /// Sends a request to be verified with a code from the user's messaging app.
    /// 
    /// It's the responsibility of the client to validate the phone number before calling this
    /// method, in order to avoid errors.
    ///
    /// - Important: The lexicon associated with this model may be removed at any time.
    /// This may not work.
    ///
    /// - Note: According to the AT Protocol specifications: "Request a verification code to be
    /// sent to the supplied phone number."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.temp.requestPhoneVerification`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/requestPhoneVerification.json
    ///
    /// - Parameter phoneNumber: The user's phone number used for sending the verification code to.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func requestPhoneVerification(to phoneNumber: String) async throws {
        guard let sessionURL = session?.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.temp.requestPhoneVerification") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Temp.RequestPhoneVerificationRequestBody(
            phoneNumber: phoneNumber
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: "application/json",
                contentTypeValue: "application/json",
                authorizationValue: nil
            )

            _ = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody
            )
        } catch {
            throw error
        }
    }
}
