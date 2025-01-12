//
//  ATRecordViewProtocol.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-12.
//

import Foundation

/// A protocol for common and helper systems for record views.
///
/// This protocol is used to make things easier to use record views. It allows for easy
/// identification and refreshing without the need to manually implement the code by hand.
///
/// When using this protocol, you must use it on a record view. An example of this is
/// ``AppBskyLexicon/Feed/PostViewDefinition``. That `stuct` includes a `uri` property, so the `id`
/// property will be able to find and quickly
public protocol ATRecordViewProtocol: Identifiable {

    /// The unique identifier for the record view.
    ///
    /// By default, the property will search for a property named `uri` and use that as the ID.
    ///
    /// If there's no such property name, you must create a custom implementation for it. To do
    /// this, create a computed property for the object and use `Mirror` to find the specific URI
    /// property that will be used as the identifier.
    ///
    /// ```swift
    /// public var id: String {
    ///     let mirror = Mirror(reflecting: self)
    ///
    ///     // Make sure you search for the property that represents a URI,
    ///     // as this is the most unique element in the object.
    ///     guard let uriProperty = mirror.children.first(where: { $0.label == "uri" })?.value as? String else {
    ///         // For safety reasons, have a fallback option, or return
    ///         // an empty string.
    ///         return ""
    ///     }
    ///
    ///     return uriProperty
    /// }
    /// ```
    ///
    /// If there truly is no URI property, you can choose another property that's unique, such
    /// as a `cid` value.
    var id: String { get }

    /// Refreshes the record view with updated information.
    ///
    /// You need to use ``ATProtocolConfiguration/init(userSession:pdsURL:configuration:logIdentifier:logCategory:logLevel:)``
    /// (to receive the required session tokens) as well as
    /// ``ATProtocolConfiguration/getSession(by:authenticationFactorToken:)`` (to make sure the
    /// session is up to date) in order to establish a connection. Once that happens, use the
    /// appropriate method to get the record view. For example, for
    /// ``AppBskyLexicon/Feed/PostViewDefinition``, you can use
    /// ``ATProtoKit/ATProtoKit/getPosts(_:)``, which returns that object.
    ///
    /// ```swift
    /// public func refresh(with session: UserSession) async throws -> ProfileRecordView? {
    ///     let config = ATProtocolConfiguration(userSession: session, pdsURL: session.pdsURL ?? "https://bsky.social")
    ///     _ = try await config.getSession()
    ///
    ///     let atProto = ATProtoKit(sessionConfiguration: config, canUseBlueskyRecords: false)
    ///     let record = try await atProto.getPosts([self.id])
    ///
    ///     return record.posts[0]
    /// }
    /// ```
    ///
    /// - Parameter session: An instance of ``UserSession``.
    /// - Returns: An updated version of the record view.
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    func refresh(with session: UserSession) async throws -> Self
}

extension ATRecordViewProtocol {

    public var id: String {
        let mirror = Mirror(reflecting: self)

        // Search for a property named "uri"
        guard let uriProperty = mirror.children.first(where: { $0.label == "uri" })?.value as? String else {
            // If no property named "uri" exists, fallback to a custom implementation
            print("The 'id' property must be explicitly implemented if 'uri' is not available.")
            return "uri not available"
        }

        return uriProperty
    }
}
