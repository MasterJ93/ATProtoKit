//
//  ATBuiltInIdentityResolver.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2026-06-30.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A lightweight, dependency-free ``ATIdentityProtocol`` conformer.
///
/// This resolver maps a decentralized identifier (DID) to its Personal Data Server (PDS)
/// service endpoint by fetching the DID document directly — without requiring ATIdentityTools
/// or an authenticated session.
///
/// It supports the `did:plc` and `did:web` methods. For richer identity handling (such as
/// handle verification or caching policies), conform a type to ``ATIdentityProtocol`` using a
/// dedicated package like ATIdentityTools instead.
public struct ATBuiltInIdentityResolver: ATIdentityProtocol {

    /// The URL session used for the lookups.
    public let urlSession: URLSession

    /// The base hostname of the PLC directory.
    public let plcDirectoryURL: String

    /// Creates a new built-in identity resolver.
    ///
    /// - Parameters:
    ///   - urlSession: The URL session used for the lookups. Defaults to `URLSession.shared`.
    ///   - plcDirectoryURL: The base hostname of the PLC directory. Defaults to
    ///   ``APIHostname/plcDirectory``.
    public init(
        urlSession: URLSession = .shared,
        plcDirectoryURL: String = APIHostname.plcDirectory
    ) {
        self.urlSession = urlSession
        self.plcDirectoryURL = plcDirectoryURL
    }

    public func resolvePDSEndpoint(from did: String) async throws -> String {
        let documentURL = try didDocumentURL(for: did)

        let (data, response) = try await urlSession.data(from: documentURL)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw ATIdentityResolverError.didDocumentUnavailable(did: did)
        }

        let document = try JSONDecoder().decode(DIDDocument.self, from: data)

        guard let service = try? document.checkServiceForATProto() else {
            throw ATIdentityResolverError.pdsServiceNotFound(did: did)
        }

        return service.serviceEndpoint.absoluteString
    }

    /// Builds the DID-document URL for a supported DID method.
    ///
    /// - Parameter did: The DID to build the document URL for.
    /// - Returns: The URL of the DID document.
    private func didDocumentURL(for did: String) throws -> URL {
        if did.hasPrefix("did:plc:") {
            // did:plc:xxxx → https://plc.directory/did:plc:xxxx
            guard let url = URL(string: "\(plcDirectoryURL)/\(did)") else {
                throw ATIdentityResolverError.invalidDID(did)
            }

            return url
        } else if did.hasPrefix("did:web:") {
            // did:web:example.com     → https://example.com/.well-known/did.json
            // did:web:example.com:a:b → https://example.com/a/b/did.json
            let identifier = String(did.dropFirst("did:web:".count))
            let segments = identifier.split(separator: ":").map(String.init)

            guard let host = segments.first?.removingPercentEncoding else {
                throw ATIdentityResolverError.invalidDID(did)
            }

            let path = segments.count > 1
                ? "/" + segments.dropFirst().joined(separator: "/") + "/did.json"
                : "/.well-known/did.json"

            guard let url = URL(string: "https://\(host)\(path)") else {
                throw ATIdentityResolverError.invalidDID(did)
            }

            return url
        } else {
            throw ATIdentityResolverError.unsupportedDIDMethod(did)
        }
    }
}
