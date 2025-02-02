//
//  SessionConfigurationTools.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-02-02.
//

import Foundation

/// A class of helper methods for ``SessionConfiguration``-conforming classes.
public class SessionConfigurationTools {

    /// An instance of ``SessionConfiguration``.
    public let sessionConfiguration: SessionConfiguration

    /// Creates an instance for the class.
    /// 
    /// - Parameter sessionConfiguration: An instance of ``SessionConfiguration``.
    public init(sessionConfiguration: SessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }

    // MARK: - Common Helpers
    /// Converts the DID document from an ``UnknownType`` object to a ``DIDDocument`` object.
    ///
    /// - Parameter didDocument: The DID document as an ``UnknownType`` object. Optional.
    /// Defaults to `nil`.
    /// - Returns: A ``DIDDocument`` object (if there's a value) or `nil` (if not).
    public func convertDIDDocument(_ didDocument: UnknownType? = nil) -> DIDDocument? {
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

    /// Checks the refresh token and refreshes the session.
    ///
    /// - Parameter refreshToken: The refresh token of the session.
    ///
    /// - Throws: ``ATProtocolConfigurationError`` if the current date is past the token's
    /// expiry date.
    public func checkRefreshToken(refreshToken: String, pdsURL: String = "https://bsky.social") async throws {
        let expiryDate = try SessionToken(sessionToken: refreshToken).payload.expiresAt
        let currentDate = Date()

        if currentDate > expiryDate {
            throw SessionConfigurationToolsError.tokensExpired(message: "The access and refresh tokens have expired.")
        }

        do {
            _ = try await self.sessionConfiguration.refreshSession(by: refreshToken, authenticationFactorToken: nil)
        } catch {
            throw error
        }
    }

    // MARK: - getSession Helpers
    /// Validates and retrieves a valid access token from the provided argument or the session object.
    ///
    /// - Parameter accessToken: An optional access token to validate.
    /// - Returns: A valid access token.
    ///
    /// - Throws: An `ATProtoError` if no access token is available.
    public func getValidAccessToken(from accessToken: String?) throws -> String {
        if let token = accessToken {
            return token
        }

        if let token = self.sessionConfiguration.accessToken {
            return token
        }

        throw SessionConfigurationToolsError.noSessionToken(message: "No session token available.")
    }

    /// Handles re-authentication and session refresh when the token is expired.
    ///
    /// - Parameter authenticationFactorToken: A token used for Two-Factor Authentication.
    /// Optional. Defaults to `nil`.
    /// - Returns: A refreshed session object.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError``, ``ATRequestPrepareError``, and
    /// ``ATProtocolConfigurationError`` for more details.
    public func handleExpiredTokenFromGetSession(
        authenticationFactorToken: String? = nil
    ) async throws -> ComAtprotoLexicon.Server.GetSessionOutput {
        do {
            _ = try await self.sessionConfiguration.refreshSession(by: nil, authenticationFactorToken: authenticationFactorToken)

            guard let didDocument = self.sessionConfiguration.didDocument else {
                throw SessionConfigurationToolsError.noSessionToken(message: "No session token found after re-authentication attempt.")
            }

            var refreshedSessionStatus: ComAtprotoLexicon.Server.GetSession.UserAccountStatus? = nil

            // UserAccountStatus conversion.
            let sessionStatus = self.sessionConfiguration.status
            switch sessionStatus {
                case .suspended:
                    refreshedSessionStatus = .suspended
                case .takedown:
                    refreshedSessionStatus = .takedown
                case .deactivated:
                    refreshedSessionStatus = .deactivated
                default:
                    refreshedSessionStatus = nil
            }

            // DIDDocument conversion.
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            let jsonData = try encoder.encode(didDocument)

            guard let rawDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(codingPath: [], debugDescription: "Failed to serialize DIDDocument into [String: Any].")
                )
            }

            var codableDictionary = [String: CodableValue]()
            for (key, value) in rawDictionary {
                codableDictionary[key] = try CodableValue.fromAny(value)
            }

            let unknownDIDDocument = UnknownType.unknown(codableDictionary)

            return ComAtprotoLexicon.Server
                .GetSessionOutput(
                    handle: self.sessionConfiguration.handle,
                    did: self.sessionConfiguration.sessionDID,
                    email: self.sessionConfiguration.email,
                    isEmailConfirmed: self.sessionConfiguration.isEmailConfirmed,
                    isEmailAuthenticationFactor: self.sessionConfiguration.isEmailAuthenticationFactorEnabled,
                    didDocument: unknownDIDDocument,
                    isActive: self.sessionConfiguration.isActive,
                    status: refreshedSessionStatus
                )
        } catch {
            throw error
        }
    }

    // MARK: - refreshSession Helpers
    /// Validates and retrieves a valid access token from the provided argument or the session object.
    ///
    /// - Parameter accessToken: An optional access token to validate.
    /// - Returns: A valid access token.
    ///
    /// - Throws: An `ATProtoError` if no access token is available.
    public func getValidRefreshToken(from refreshToken: String?) throws -> String {
        if let token = refreshToken {
            return token
        }

        let token = self.sessionConfiguration.refreshToken
        return token
    }

    /// Handles re-authentication and session refresh when the token is expired.
    ///
    /// - Parameter authenticationFactorToken: A token used for Two-Factor Authentication.
    /// Optional. Defaults to `nil`.
    /// - Returns: A refreshed session object.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError``, ``ATRequestPrepareError``, and
    /// ``ATProtocolConfigurationError`` for more details.
    public func handleExpiredTokenFromRefreshSession(
        authenticationFactorToken: String? = nil
    ) async throws -> ComAtprotoLexicon.Server.RefreshSessionOutput {
        do {
            try await self.sessionConfiguration.authenticate(authenticationFactorToken: authenticationFactorToken)

            guard let didDocument = self.sessionConfiguration.didDocument else {
                throw SessionConfigurationToolsError.noSessionToken(message: "No session token found after re-authentication attempt.")
            }

            var refreshedSessionStatus: ComAtprotoLexicon.Server.RefreshSession.UserAccountStatus? = nil

            // UserAccountStatus conversion.
            let sessionStatus = self.sessionConfiguration.status
            switch sessionStatus {
                case .suspended:
                    refreshedSessionStatus = .suspended
                case .takedown:
                    refreshedSessionStatus = .takedown
                case .deactivated:
                    refreshedSessionStatus = .deactivated
                default:
                    refreshedSessionStatus = nil
            }

            // DIDDocument conversion.
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            let jsonData = try encoder.encode(didDocument)

            guard let rawDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(codingPath: [], debugDescription: "Failed to serialize DIDDocument into [String: Any].")
                )
            }

            var codableDictionary = [String: CodableValue]()
            for (key, value) in rawDictionary {
                codableDictionary[key] = try CodableValue.fromAny(value)
            }

            let unknownDIDDocument = UnknownType.unknown(codableDictionary)

            return ComAtprotoLexicon.Server.RefreshSessionOutput(
                accessToken: self.sessionConfiguration.accessToken!,
                refreshToken: self.sessionConfiguration.refreshToken,
                handle: self.sessionConfiguration.handle,
                did: self.sessionConfiguration.sessionDID,
                didDocument: unknownDIDDocument,
                isActive: self.sessionConfiguration.isActive,
                status: refreshedSessionStatus
            )
        } catch {
            throw error
        }
    }
}
