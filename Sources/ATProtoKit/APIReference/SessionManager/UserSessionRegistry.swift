//
//  UserSessionRegistry.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-04-06.
//

import Foundation

/// A registry that manages `UserSession` instances, keyed by `UUID`.
///
/// While most applications would need to use one instance of `UserSession`, this
/// `actor` allows the ability to have multiple instances of `UserSession`. This is particularly
/// useful for AT Protocol applications that lets users log into multiple accounts at once.
///
/// Even without that sort of use case, this allows for any part of ATProtoKit to gain access
/// to a session in a decoupled manner.
public actor UserSessionRegistry {

    /// A singleton instance of `UserSessionRegistry`.
    public static var shared = UserSessionRegistry()

    /// The internal registry of user sessions.
    private var sessions: [UUID: UserSession] = [:]

    /// Registers a new user session with a unique `UUID`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the session.
    ///   - session: The `UserSession` to be stored.
    public func register(_ id: UUID, session: UserSession) {
        sessions[id] = session
    }

    /// Retrieves a user session by its `UUID`.
    ///
    /// - Parameter id: The UUID associated with the session.
    /// - Returns: The `UserSession` if it exists, or `nil` if it doesn't.
    public func getSession(for id: UUID) -> UserSession? {
        return sessions[id]
    }

    /// Checks whether a session exists for the given UUID.
    ///
    /// - Parameter id: The UUID to check for.
    /// - Returns: `true` if the session exists, or `false` if not.
    public func containsSession(for id: UUID) -> Bool {
        return sessions.keys.contains(id)
    }

    /// Updates an existing instance of `UserSession` with a new instance.
    ///
    /// - Parameters:
    ///   - id: The UUID of the existing session to update.
    ///   - newSession: The updated `UserSession` instance.
    /// - Returns: `true` if the update succeeded, `false` if the session didn’t exist.
    public func update(_ id: UUID, with newSession: UserSession) -> Bool {
        guard sessions.keys.contains(id) else {
            return false
        }

        sessions[id] = newSession
        return true
    }

    /// Removes a specific user session by UUID.
    ///
    /// - Parameter id: The UUID of the session to remove.
    public func removeSession(for id: UUID) {
        sessions.removeValue(forKey: id)
    }

    /// Removes all user sessions from the registry.
    public func removeAllSessions() {
        sessions.removeAll()
    }
}
