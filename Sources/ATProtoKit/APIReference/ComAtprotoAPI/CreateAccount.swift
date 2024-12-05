//
//  CreateAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-12-05.
//

import Foundation

extension ATProtoKit {

    /// Creates an account in the AT Protocol.
    ///
    /// - Note: `plcOp` may be updated when full account migration is implemented.
    ///
    /// - Bug: `plcOp` is currently broken: there's nothing that can be used for this at the
    /// moment while Bluesky continues to work on account migration. Until everything settles
    /// and they have a concrete example of what to do, don't use it. In the meantime, leave it
    /// at `nil`.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an account. Implemented
    /// by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createAccount.json
    ///
    /// - Parameters:
    ///   - email: The email of the user. Optional
    ///   - handle: The handle the user wishes to use.
    ///   - existingDID: A decentralized identifier (DID) that has existed before and will be
    ///   used to be imported to the new account. Optional.
    ///   - inviteCode: The invite code for the user. Optional.
    ///   - verificationCode: A verification code.
    ///   - verificationPhone: A code that has come from a text message in the user's
    ///   phone. Optional.
    ///   - password: The password the user will use for the account. Optional.
    ///   - recoveryKey: DID PLC rotation key (aka, recovery key) to be included in PLC
    ///   creation operation. Optional.
    ///   - plcOp: A signed DID PLC operation to be submitted as part of importing an existing
    ///   account to this instance. Optional.
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func createAccount(
        email: String? = nil,
        handle: String,
        existingDID: String? = nil,
        inviteCode: String? = nil,
        verificationCode: String? = nil,
        verificationPhone: String? = nil,
        password: String? = nil,
        recoveryKey: String? = nil,
        plcOperation: UnknownType? = nil,
        pdsURL: String = "https://bsky.social"
    ) async throws -> ComAtprotoLexicon.Server.CreateAccountOutput {
        guard let requestURL = URL(string: "\(pdsURL)/xrpc/com.atproto.server.createAccount") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        let requestBody = ComAtprotoLexicon.Server.CreateAccountRequestBody(
            email: email,
            handle: handle,
            existingDID: existingDID,
            inviteCode: inviteCode,
            verificationCode: verificationCode,
            verificationPhone: verificationPhone,
            password: password,
            recoveryKey: recoveryKey,
            plcOp: plcOperation
        )

        do {
            let request = APIClientService.createRequest(
                forRequest: requestURL,
                andMethod: .post,
                acceptValue: nil,
                contentTypeValue: nil,
                authorizationValue: nil
            )
            let response = try await APIClientService.shared.sendRequest(
                request,
                withEncodingBody: requestBody,
                decodeTo: ComAtprotoLexicon.Server.CreateAccountOutput.self
            )

            return response
        } catch {
            throw error
        }
    }
}
