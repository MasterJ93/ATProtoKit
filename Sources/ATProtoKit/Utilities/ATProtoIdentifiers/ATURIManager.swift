//
//  ATURIManager.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-09.
//

import Foundation

/// Identifies and validates AT URIs.
public struct ATURIManager {
    
    /// The `at://` prefix portion of the URI.
    public let `protocol`: String = "at://"

    /// A combination of the `at://` prefix and authority segments.
    public var origin: String {
        return "at://\(authoritySegment)"
    }

    /// The authority segment portion of the URI.
    public var authoritySegment: String {
        get {
            return authority
        }
        set {
            authority = newValue
        }
    }

    /// The collection portion of the path segement.
    public var collection: String {
        get {
            let parts = pathname.split(separator: "/").filter { !$0.isEmpty }
            return parts.first.map(String.init) ?? ""
        }
        set {
            var parts = pathname.split(separator: "/").filter { !$0.isEmpty }
            if parts.isEmpty {
                parts.append(Substring(newValue))
            } else {
                parts[0] = Substring(newValue)
            }
            pathname = "/" + parts.joined(separator: "/")
        }
    }

    /// The search query within the URI.
    public var searchQuery: String {
        get {
            return searchParameters ?? ""
        }
        set {
            searchParameters = newValue
        }
    }

    /// The Record Key portion of the path segment.
    ///
    /// If there's only one segment within the path segment, this will return `undefined`.
    public var recordKey: String {
        get {
            let parts = pathname.split(separator: "/").filter { !$0.isEmpty }
            return parts.count > 1 ? String(parts[1]) : ""
        }
        set {
            var parts = pathname.split(separator: "/").filter { !$0.isEmpty }
            if parts.isEmpty {
                parts.append("undefined")
            } else if parts.count == 1 {
                parts.append(Substring(newValue))
            } else {
                parts[1] = Substring(newValue)
            }
            pathname = "/" + parts.joined(separator: "/")
        }
    }

    /// The authority segment portion of the URI.
    private var authority: String

    /// The path segment portion of the URI.
    ///
    /// This could include the collection and/or Record Key.
    private var pathname: String

    /// A search query within the URI.
    private var searchParameters: String?

    /// The fragment segment portion of the URI.
    public var fragmentSegment: String

    /// Initializes a new instance, while putting each segment into separate properties.
    ///
    /// - Parameters:
    ///   - atURI: The URI itself.
    ///
    /// - Throws: ``ATURIError/invalidURI``, which suggests the URI is invalid.
    public init(atURI: String) throws {
        var parsed: (String?, String?, String?, String?)

        do {
            parsed = try ATURIManager.parse(atURI)
        } catch {
            throw ATURIError.invalidURI
        }

        self.fragmentSegment = parsed.0 ?? ""
        self.authority = parsed.1 ?? ""
        self.pathname = parsed.2 ?? ""
        self.searchParameters = parsed.3 ?? ""
    }

    /// Parses a URI from a regular expression.
    /// 
    /// The regular expression contains sections for the `at://` prefix,
    /// a decentralized identifier (DID), a name segment, a path segment, a query for searching,
    /// and a fragment segment.
    ///
    /// - Parameter atURI: The URI to parse.
    /// - Returns: A tuple, separating the URI into the following:\
    ///   \- the fragment segment,\
    ///   \- the authority segment,\
    ///   \- the path segment, and\
    ///   \- search parameters.
    ///
    /// - Throws: ``ATURIError/undefinedURI``, suggesting the URI is undefined.
    public static func parse(_ atURI: String) throws -> (fragment: String?, authority: String?, pathname: String?, searchParameters: String?) {
        let uriRegex = #"^(at:\/\/)?((?:did:[a-z0-9:%-]+)|(?:[a-z0-9][a-z0-9.:-]*))(\/[^?#\s]*)?(\?[^#\s]+)?(#[^\s]+)?$"#
        guard let match = ATProtoTools.match(uriRegex, in: atURI) else {
            throw ATURIError.undefinedURI
        }

        let fragment = match[5]
        let authority = match[2]
        let pathname = match[3]
        let searchParameters = match[4]

        var components = URLComponents()
        if let searchParameters = searchParameters, !searchParameters.isEmpty {
            components.query = String(searchParameters.dropFirst())
        }

        return (fragment, authority, pathname, searchParameters)
    }

    public func toString() -> String {
        // Ensure pathname starts with a "/"
        var path = pathname.isEmpty ? "/" : pathname
        if !path.hasPrefix("/") {
            path = "/" + path
        }

        // Ensure search parameters start with "?" if not empty
        var query = searchParameters ?? ""
        if !query.isEmpty && !query.hasPrefix("?") {
            query = "?" + query
        }

        // Ensure fragment starts with "#" if not empty
        var hashFragment = fragmentSegment
        if !hashFragment.isEmpty && !hashFragment.hasPrefix("#") {
            hashFragment = "#" + hashFragment
        }

        return "at://\(authoritySegment)\(path)\(query)\(hashFragment)"
    }

    public func normalize() -> String {
        var uriSegments = toString().split(separator: "/").map(String.init)

        if !uriSegments[1].starts(with: "did") {
            uriSegments[1] = HandleManager().normalize(uriSegments[1])
        }

        return uriSegments.joined(separator: "/")
    }

    /// Ensures the AT URI is valid.
    ///
    /// - Parameter atURI: The URI to be validated.
    ///
    /// - Throws: An ``ATURIError``, indicating the URI is invalid.
    public func validate(_ atURI: String) throws {
        let uriSegments = atURI.split(separator: "#", omittingEmptySubsequences: false)

        if uriSegments.count > 2 {
            throw ATURIError.tooManyHashtags
        }

        let fragmentSegment = uriSegments.count > 1 ? uriSegments[1] : nil
        let uriSegment = uriSegments[0]

        let asciiCheck = #"^[a-zA-Z0-9._~:@!$&')(*+,;=%/-]*$"#
        guard let _ = ATProtoTools.match(asciiCheck, in: String(uriSegment)) else {
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

            let fragmentCheck = #"^\/[a-zA-Z0-9._~:@!$&')(*+,;=%[\]/-]*$"#
            guard let match = ATProtoTools.match(fragmentCheck, in: String(fragment)) else {
                throw ATURIError.disallowedASCIICharacters
            }
        }

        if uriSegment.count > 8_192 {
            throw ATURIError.tooLong
        }
    }
}
