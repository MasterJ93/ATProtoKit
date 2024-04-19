//
//  ATProtocolConfiguration.swift
//  
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

/// Manages authentication and session operations for the a user account in the ATProtocol.
public class ATProtocolConfiguration: ProtocolConfiguration {
    /// The user's handle identifier in their account.
    public private(set) var handle: String
    /// The app password of the user's account.
    public private(set) var appPassword: String
    /// The URL of the Personal Data Server (PDS).
    public private(set) var pdsURL: String
    
    /// Initializes a new instance of `ATProtocolConfiguration`, which assembles a new session for the user account.
    ///
    /// - Parameters:
    ///   - handle: The user's handle identifier in their account.
    ///   - appPassword: The app password of the user's account.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    public init(handle: String, appPassword: String, pdsURL: String = "https://bsky.social") {
        self.handle = handle
        self.appPassword = appPassword
        self.pdsURL = !pdsURL.isEmpty ? pdsURL : "https://bsky.social"
    }
    
    /// Attempts to authenticate the user into the server.
    ///
    /// - Note: According to the AT Protocol specifications: "Handle or other identifier supported by the server for the authenticating user."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createSession.json
    /// - Parameter authenticationFactorToken: A token used for Two-Factor Authentication. Optional.
    /// - Returns: A `Result` containing ``UserSession`` on success or an `Error` on failure.
    public func authenticate(authenticationFactorToken: String? = nil) async throws -> Result<UserSession, Error> {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createSession") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let credentials = SessionCredentials(
            identifier: handle,
            password: appPassword
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post)
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: credentials,
                                                                  decodeTo: UserSession.self)
            response.pdsURL = self.pdsURL

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    /// Creates an a new account for the user.
    ///
    /// - Note: `plcOp` may be updated when full account migration is implemented.
    ///
    /// - Bug: `plcOp` is currently broken: there's nothing that can be used for this at the moment while Bluesky continues to work on account migration. Until everything settles and they have a
    /// concrete example of what to do, don't use it. In the meantime, leave it at `nil`.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an account. Implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createAccount.json
    ///
    /// - Parameters:
    ///   - email: The email of the user. Optional
    ///   - handle: The handle the user wishes to use.
    ///   - existingDID: A decentralized identifier (DID) that has existed before and will be used to be imported to the new account. Optional.
    ///   - inviteCode: The invite code for the user. Optional.
    ///   - verificationCode: A verification code.
    ///   - verificationPhone: A code that has come from a text message in the user's phone. Optional.
    ///   - password: The password the user will use for the account. Optional.
    ///   - recoveryKey: DID PLC rotation key (aka, recovery key) to be included in PLC creation operation. Optional.
    ///   - plcOp: A signed DID PLC operation to be submitted as part of importing an existing account to this instance. Optional.
    /// - Returns: A `Result`, containing either a ``UserSession`` if successful, or an `Error` if not.
    public func createAccount(email: String? = nil, handle: String, existingDID: String? = nil, inviteCode: String? = nil,
                              verificationCode: String? = nil, verificationPhone: String? = nil, password: String? = nil, recoveryKey: String? = nil,
                              plcOp: UnknownType? = nil) async throws -> Result<UserSession, Error> {
        guard let requestURL = URL(string: "\(self.pdsURL)/xrpc/com.atproto.server.createAccount") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        let requestBody = ServerCreateAccount(
            email: email,
            handle: handle,
            existingDID: existingDID,
            inviteCode: inviteCode,
            verificationCode: verificationCode,
            verificationPhone: verificationPhone,
            password: password,
            recoveryKey: recoveryKey,
            plcOp: plcOp
        )

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         acceptValue: nil,
                                                         contentTypeValue: nil,
                                                         authorizationValue: nil)
            let response = try await APIClientService.sendRequest(request,
                                                                  withEncodingBody: requestBody,
                                                                  decodeTo: UserSession.self)
            response.pdsURL = self.pdsURL

            return .success(response)
        } catch {
            return .failure(error)
        }
    }

    /// Fetches an existing session using an access token.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about the current auth session. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.getSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/getSession.json
    ///
    /// - Parameters:
    ///   - accessToken: The access token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: Returns: A `Result` containing either ``SessionResponse`` if successful, or an `Error` if not.
    public func getSession(by accessToken: String,
                           pdsURL: String? = nil) async throws -> Result<SessionResponse, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.getSession") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .get,
                                                         authorizationValue: "Bearer \(accessToken)")
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: SessionResponse.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }

    /// Refreshes the user's session using a refresh token.
    /// 
    /// - Note: According to the AT Protocol specifications: "Refresh an authentication session. Requires auth using the 'refreshJwt' (not the 'accessJwt')."
    /// 
    /// - SeeAlso: This is based on the [`com.atproto.server.refreshSession`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/refreshSession.json
    /// 
    /// - Parameters:
    ///   - refreshToken: The refresh token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A `Result`, containing either a ``UserSession`` if successful, or an `Error` if not.
    public func refreshSession(using refreshToken: String,
                               pdsURL: String? = nil) async throws -> Result<UserSession, Error> {
        guard let sessionURL = pdsURL != nil ? pdsURL : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.refreshSession") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(refreshToken)")

            let response = try await APIClientService.sendRequest(request, decodeTo: UserSession.self)
            response.pdsURL = self.pdsURL

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    /// Refreshes the user's session using a refresh token.
    /// 
    /// - Note: According to the AT Protocol specifications: "Delete the current session. Requires auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.deleteSession`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/deleteSession.json
    ///
    /// - Parameters:
    ///   - accessToken: The access token for the session.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    public func deleteSession(using accessToken: String,
                              pdsURL: String? = nil) async throws {
        guard let sessionURL = pdsURL != nil ? pdsURL : self.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.server.deleteSession") else {
            throw ATRequestPrepareError.invalidRequestURL
        }

        do {
            let request = APIClientService.createRequest(forRequest: requestURL,
                                                         andMethod: .post,
                                                         authorizationValue: "Bearer \(accessToken)")

            _ = try await APIClientService.sendRequest(request,
                                                       withEncodingBody: nil)
        } catch {
            throw error
        }
    }
}
