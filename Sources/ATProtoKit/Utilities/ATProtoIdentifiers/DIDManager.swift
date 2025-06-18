//
//  DIDManager.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-07.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Identifies and validates decentralized identifiers (DIDs).
public struct DIDManager {

    /// Normalizes the decentralized identifier (DID).
    ///
    /// - Parameter did: The DID to be normalized.
    /// - Returns: The DID with the prefix `did:` normalized with the `did` prefix all lowercased.
    ///
    /// - Throws: An ``ATDIDError``, which indicates the DID is not valid.
    public func normalize(_ did: String) -> String {
        var didSegments = did.split(separator: ":").map(String.init)

        if let firstSegment = didSegments.first {
            didSegments[0] = firstSegment.lowercased()
        }

        return didSegments.joined(separator: ":")
    }

    /// Ensures the decentralized identifier (DID) is valid.
    ///
    /// - Parameter did: The DID to be validated.
    ///
    /// - Throws: An ``ATDIDError``, indicating the DID is invalid.
    public func validate(_ did: String) throws {
        let asciiCheck = #"^[a-zA-Z0-9._:%-]*$"#

        guard ATProtoTools.match(asciiCheck, in: String(did)) != nil else {
            throw ATURIError.disallowedASCIICharacters
        }

        let segments = did.split(separator: ":")

        guard segments.count >= 3 else {
            throw ATDIDError.notEnoughSegments
        }

        guard segments[0] == "did" else {
            throw ATDIDError.noValidPrefix
        }

        let lowercasedLetters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        guard segments[1].rangeOfCharacter(from: lowercasedLetters.inverted) != nil else {
            throw ATDIDError.didMethodNotLowercased
        }

        guard did.hasSuffix(":") == false,
              did.hasSuffix("%") == false else {
            throw ATDIDError.invalidSuffixCharacter
        }

        guard did.count <= 2048 else {
            throw ATDIDError.tooLong
        }
    }
}
