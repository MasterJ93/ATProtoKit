//
//  SessionConfiguration.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

/// Defines the requirements for session configurations within ATProtoKit.
///
/// This protocol contains default implementations for the methods used. You can choose
/// to use those implementations, or create your own.
///
/// When implementing this protocol onto your `class`, you should keep in mind of a few things:
/// - `class`es that conform to `SessionConfiguration` must be marked `final` and
/// adopt `Sendable`.
/// - You should use `UserSessionRegistry` to manage `UserSession` instances.
/// - When deleting a session, make sure that `deleteSession` removes the instance
/// from `UserSessionRegistry`.
/// - Accessing the access token, refresh token, or password requires
/// using `KeychainProtocol`.
public protocol SessionConfiguration: AnyObject, Sendable {

    /// The base URL of the Personal Data Server (PDS) with which the AT Protocol interacts.
    ///
    /// This URL is used to make network requests to the PDS for various operations, such as
    /// session creation, refresh, and deletion.
    var pdsURL: String { get }

    /// An instance of `URLSessionConfiguration`.
    var configuration: URLSessionConfiguration { get }

    /// A `UUID` object specific to the `UserSession` instance.
    ///
    /// This is used to look for the `UserSession` instance within `UserSessionRegistry`.
    var instanceUUID: UUID { get }

    /// The async stream that receives user-provided authentication codes.
    ///
    /// This stream should be awaited by conforming types to receive
    /// user input asynchronously during the authentication process.
    var codeStream: AsyncStream<String> { get }

    /// The continuation used to yield new user input into the `codeStream`.
    ///
    /// Conforming types should call `codeContinuation.yield(_:)` to
    /// provide new authentication codes from the user.
    var codeContinuation: AsyncStream<String>.Continuation { get }

    /// An instance of `SecureKeychainProtocol`.
    var keychainProtocol: SecureKeychainProtocol { get }

    /// Creates an a new account for the user.
    ///
    /// - Note: `plcOp` may be updated when full account migration is implemented.
    ///
    /// - Bug: `plcOp` is currently broken: there's nothing that can be used for this at the
    /// moment while Bluesky continues to work on account migration. Until everything settles
    /// and they have a concrete example of what to do, don't use it. In the meantime, leave it
    /// at `nil`.
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
    ///   - plcOperation: A signed DID PLC operation to be submitted as part of importing an
    ///   existing account to this instance. Optional.
    /// - Returns: An instance of an authenticated user session within the AT Protocol. It may also
    /// have logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func createAccount(
        email: String?,
        handle: String,
        existingDID: String?,
        inviteCode: String?,
        verificationCode: String?,
        verificationPhone: String?,
        password: String?,
        recoveryKey: String?,
        plcOperation: UnknownType?
    ) async throws

    /// Attempts to authenticate with the PDS.
    ///
    /// This method should implement the necessary logic to authenticate the user against the PDS,
    /// while adding the password and tokens to the `keychainProtocol` instance. Additional
    /// Two-Factor Authentication implementations must be handled as well.
    ///
    /// - Parameters:
    ///   - handle: The hanle used for the account.
    ///   - password: The password used for the account.
    ///
    /// - Throws: An error if there are issues creating the request or communicating with the PDS.
    func authenticate(with handle: String, password: String) async throws

    /// Fetches an existing session using an access token.
    ///
    /// If the access token is invalid, then a new one will be created, either by refeshing a
    /// session, or by re-authenticating.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func getSession() async throws

    /// Refreshes the user's session using a refresh token.
    ///
    /// If the refresh token is invalid, the method will re-authenticate and try again.
    ///
    /// - Note: If the method throws an error saying that an authentication token is required,
    /// re-trying the method with the `authenticationFactorToken` argument filled should
    /// solve the issue.
    ///
    /// When the method completes, ``ATProtocolConfiguration/session`` will be updated with a
    /// new instance of an authenticated user session within the AT Protocol. It may also have
    /// logging information, as well as the URL of the Personal Data Server (PDS).
    ///
    /// - Returns: Information of the user account's new session.
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func refreshSession() async throws

    /// Deletes the user session.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func deleteSession() async throws
}

extension SessionConfiguration {

    public func createAccount(
        email: String?,
        handle: String,
        existingDID: String?,
        inviteCode: String?,
        verificationCode: String?,
        verificationPhone: String?,
        password: String?,
        recoveryKey: String?,
        plcOperation: UnknownType?
    ) async throws {
        do {
            let response = try await ATProtoKit(pdsURL: self.pdsURL, canUseBlueskyRecords: false).createAccount(
                email: email,
                handle: handle,
                existingDID: existingDID,
                inviteCode: inviteCode,
                verificationCode: verificationCode,
                verificationPhone: verificationPhone,
                password: password,
                recoveryKey: recoveryKey,
                plcOperation: plcOperation
            )

            guard let didDocument = SessionConfigurationHelpers.convertDIDDocument(response.didDocument) else {
                throw DIDDocument.DIDDocumentError.emptyArray
            }

            let atService = try didDocument.checkServiceForATProto()
            let serviceEndpoint = atService.serviceEndpoint

            let userSession = UserSession(
                handle: response.handle,
                sessionDID: response.did,
                email: email,
                isEmailConfirmed: nil,
                isEmailAuthenticationFactorEnabled: nil,
                accessToken: response.accessToken,
                refreshToken: response.refreshToken,
                didDocument: didDocument,
                isActive: nil,
                status: nil,
                serviceEndpoint: serviceEndpoint,
                pdsURL: self.pdsURL
            )
        } catch {
            throw error
        }
    }

    
}

public enum SessionConfigurationHelpers {

    /// Converts the DID document from an ``UnknownType`` object to a ``DIDDocument`` object.
    ///
    /// - Parameter didDocument: The DID document as an ``UnknownType`` object. Optional.
    /// Defaults to `nil`.
    /// - Returns: A ``DIDDocument`` object (if there's a value) or `nil` (if not).
    public static func convertDIDDocument(_ didDocument: UnknownType? = nil) -> DIDDocument? {
        var decodedDidDocument: DIDDocument? = nil

        do {
            if let didDocument = didDocument,
               let jsonData = try didDocument.toJSON() {
                let decoder = JSONDecoder()
                decodedDidDocument = try decoder.decode(DIDDocument.self, from: jsonData)
            }
        } catch {
            return nil
        }

        return decodedDidDocument
    }

    
}
