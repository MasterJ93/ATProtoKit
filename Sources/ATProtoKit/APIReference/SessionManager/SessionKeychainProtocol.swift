//
//  SessionKeychainProtocol.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-03-01.
//

import Foundation

/// A protocol for managing keychain items.
public protocol SessionKeychainProtocol {
    
    /// Stores the provided password securely.
    ///
    /// - Parameter password: The user's password to store.
    /// - Throws: A `KeychainError` if the operation fails.
    func storePassword(_ password: String) throws
    
    /// Retrieves the stored password.
    ///
    /// - Returns: The stored password, or `nil` if not found.
    /// - Throws: A `KeychainError` if the operation fails.
    func retrievePassword() throws -> String?
    
    /// Updates the stored password with a new value.
    ///
    /// - Parameter password: The new password to update.
    /// - Throws: A `KeychainError` if the operation fails.
    func updatePassword(_ password: String) throws
    
    /// Removes the stored password.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    func removePassword() throws
    
    /// Stores the provided refresh token securely.
    ///
    /// - Parameter token: The refresh token to store.
    /// - Throws: A `KeychainError` if the operation fails.
    func storeRefreshToken(_ token: String) throws
    
    /// Retrieves the stored refresh token.
    ///
    /// - Returns: The stored refresh token, or `nil` if not found.
    /// - Throws: A `KeychainError` if the operation fails.
    func retrieveRefreshToken() throws -> String?
    
    /// Updates the stored refresh token with a new value.
    ///
    /// - Parameter token: The new refresh token to update.
    /// - Throws: A `KeychainError` if the operation fails.
    func updateRefreshToken(_ token: String) throws
    
    /// Removes the stored refresh token.
    ///
    /// - Throws: A `KeychainError` if the operation fails.
    func removeRefreshToken() throws
}
