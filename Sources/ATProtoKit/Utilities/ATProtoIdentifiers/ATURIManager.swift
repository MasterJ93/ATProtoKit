//
//  ATURIManager.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-09.
//

import Foundation

public struct ATURIManager {

    public func validate(_ atURI: String) throws {
        let uriSegments = atURI.split(separator: "#", omittingEmptySubsequences: false)

        if uriSegments.count > 2 {
            throw ATURIError.tooManyHashtags
        }

        let fragmentSegment = uriSegments.count > 1 ? uriSegments[1] : nil
        let uriSegment = uriSegments[0]

        let asciiCheck = try Regex(#"^[a-zA-Z0-9._~:@!$&')(*+,;=%/-]*$"#)
        guard uriSegment.wholeMatch(of: asciiCheck) != nil else {
            throw ATURIError.disallowedASCIICharacters
        }

        let segments = uriSegment.split(separator: "/", omittingEmptySubsequences: false)

        if (segments.count >= 3 && (segments[0] != "at:" || segments[1].count != 0)) {
            throw ATURIError.missingPrefix
        }

        if segments.count < 3 {
            throw ATURIError.notEnoughSegments
        }

        do {
            if segments[2].starts(with: "did:") {
                let did = String(segments[2])
                try DIDManager().validate(did)
            } else {
                let handle = String(segments[2])
                try HandleManager().validate(handle)
            }
        } catch {
            throw ATURIError.invalidAuthority
        }

        if segments.count >= 4 {
            if segments[3].count == 0 {
                throw ATURIError.slashWithoutPathSegmentFound
            }

            do {
                let nsid = String(segments[3])
                _ = try NSIDManager(nsid: nsid)
            } catch {
                throw ATURIError.invalidNSID
            }
        }

        if segments.count >= 5 {
            if segments[4].count == 0 {
                throw ATURIError.slashAfterCollectionWithoutRecordKey
            }
        }

        if segments.count >= 6 {
            throw ATURIError.tooManySegments
        }

        if let fragment = fragmentSegment, !fragment.isEmpty {
            if fragment.first != "/" {
                throw ATURIError.invalidOrEmptyFragment
            }

            let fragmentCheck = try Regex(#"^\/[a-zA-Z0-9._~:@!$&')(*+,;=%[\]/-]*$"#)
            guard fragment.wholeMatch(of: fragmentCheck) != nil else {
                throw ATURIError.disallowedASCIICharactersInFragment
            }
        }

        if uriSegment.count > 8_192 {
            throw ATURIError.tooLong
        }

    }

    public func validateViaRegex(_ atURI: String) throws {
        let atURIRegex = try Regex(#"^at:\/\/(?<authority>[a-zA-Z0-9._:%-]+)(\/(?<collection>[a-zA-Z0-9-.]+)(\/(?<rkey>[a-zA-Z0-9._~:@!$&%')(*+,;=-]+))?)?(#(?<fragment>\/[a-zA-Z0-9._~:@!$&%')(*+,;=\-[\]/\\]*))?$"#)

        guard let match = atURI.wholeMatch(of: atURIRegex) else {
            throw ATURIError.failedToValidateViaRegex
        }

        let authoritySegment = match.output["authority"]?.value as? String
        let collectionSegment = match.output["collection"]?.value as? String

        if let authority = authoritySegment {
            do {
                try HandleManager().validate(authority)
            } catch {
                do {
                    try DIDManager().validate(authority)
                } catch {
                    throw ATURIError.invalidAuthority
                }
            }
        } else {
            throw ATURIError.failedToValidateViaRegex
        }

        if let collection = collectionSegment {
            do {
                _ = try NSIDManager(nsid: collection)
            } catch {
                throw ATURIError.invalidNSID
            }
        }

        if atURI.count > 8_192 {
            throw ATURIError.tooLong
        }
    }
}
