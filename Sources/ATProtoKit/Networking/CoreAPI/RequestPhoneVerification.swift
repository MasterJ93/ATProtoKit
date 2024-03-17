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
    /// It's the responsibility of the client to validate the phone number before calling this method, in order to avoid errors.
    ///
    /// - Important: The lexicon associated with this model may be removed at any time. This may not work.
    ///
    /// - Parameter textTo: The user's phone number used for sending the verification code to.
    public func requestPhoneVerification(to phoneNumber: String) async throws {
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.temp.requestPhoneVerification") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = TempRequestPhoneVerification(phoneNumber: phoneNumber)

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: "application/json",
                                                         authorizationValue: nil)

            try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: TempCheckSignupQueueOutput.self)
        } catch {
            throw error
        }
    }
}
