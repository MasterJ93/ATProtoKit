//
//  ATIdentityProtocol.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-08-22.
//

// TODO: Create article on resolving identities with ATIdentityProtocol.
/// A protocol for resolving decentralized identifiers (DIDs) or handles for user accounts in the
/// AT Protocol.
///
/// When implementing this protocol, make sure to utilize the proper methods and properties
/// within the package being used, as the protocol’s methods will be directly called within ATProtoKit itself.
///
/// If the protocol is being used for any custom lexicon methods or models, prefer using the
/// methods over using the identity resolution packages directly.
///
/// - Tip: ATIdentityTools automatically conforms to `ATIdentityProtocol`, making it as
/// straightforward as importing ATIdentityTools as a dependency in your project and adding it to
/// any location that requires an `ATIdentityProtocol`-conforming object.\
/// \
/// If you prefer to use your own Swift package or code for identity resolution, refer to the
/// article “Resolve Identities With ATIdentityProtocol”.
public protocol ATIdentityProtocol {

    /// Retireves the user account's Personal Data Server (PDS) service endpoint by its
    /// decentralized identifier (DID).
    ///
    /// Implement this method by calling the method that finds the DID Document associated with the
    /// user account's DID Then, get the service endpoint from the DID Document. That endpoint is the
    /// base URL associated with the PDS.
    ///
    /// - Parameter did: The DID to use for finding its PDS service endpoint.
    /// - Returns: A string representation of the PDS service endpoint associated with the user account.
    func resolvePDSEndpoint(from did: String) async throws -> String
}
