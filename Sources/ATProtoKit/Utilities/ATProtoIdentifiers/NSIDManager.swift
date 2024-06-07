//
//  NSIDManager.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-07.
//

import Foundation

/// A class that Identifies and validates Namespaced Identifiers (NSIDs).
public class NSIDManager {

    /// An array of segments for .
    private var segments: [String] = []

    /// Returns the authority segment of the Namespaced Identifier (NSID).
    ///
    /// This will show the authority segment the same way you see a hostname. Example: instead of
    /// seeing `app.bsky`, the property will display `bsky.app`.
    public var authority: String {
        return Array(segments.prefix(2).reversed()).joined(separator: ".")
    }

    /// Returns the name segement of the Namespaced Identifier (NSID).
    public var name: String {
        return Array(segments.dropFirst(2)).joined(separator: ".")
    }

    /// Returns the subdomain segement of the Namespaced Identifier (NSID). Optional.
    ///
    /// If the NSID only has three segments, then the property will return `nil`.
    ///
    /// ```swift
    /// let nsidWithSubdomain = NSIDManager(nsid: app.bsky.feed.post)
    /// let nsidWithoutSubdomain = NSIDManager(nsid: app.bsky.feed)
    ///
    /// print(nsidWithSubdomain)    // Returns "feed".
    /// print(nsidWithoutSubdomain) // Returns nil.
    /// ```
    public var subdomain: String? {
        if segments.count > 3 {
            return segments[3]
        }

        return nil
    }

    /// Initializes the class and ensures the Namespaced Identifier (NSID) is valid.
    /// 
    /// - Parameter nsid: The Namespaced Identifier (NSID) to validate.
    ///
    /// - Throws: An ``ATNSIDError``, indicating the NSID is invalid.
    public init(nsid: String) throws {

    }
    
    /// Parses the given Namespaced Identifier (NSID) into different segments.
    ///
    /// - Parameter nsid: The NSID to parse.
    /// - Returns: An instance of ``NSIDManager``, containing a valid NSID split into segments.
    ///
    /// - Throws: An ``ATNSIDError``, indicating the NSID is invalid.
    public static func parse(_ nsid: String) throws -> NSIDManager {
        return try NSIDManager(nsid: nsid)
    }

    /// Creates a new Namespaced Identifier (NSID).
    ///
    /// - Parameters:
    ///   - authority: The domain authority segment of the NSID.
    ///   - name: The name segement of the NSID.
    /// - Returns: An instance of ``NSIDManager``, containing a valid NSID split into segments.
    ///
    /// - Throws: An ``ATNSIDError``, indicating the NSID is invalid.
    public static func create(authority: String, name: String) throws -> NSIDManager {
        var authorityArray = authority.split(separator: ".").map(String.init)
        authorityArray.append(name)

        let segements = authorityArray.joined(separator: ".")
        return try NSIDManager(nsid: segements)
    }

    /// Indicates whether the Namespaced Identifier (NSID) is valid or not.
    /// 
    /// - Parameter nsid: The Namespaced Identifier (NSID) to validate.
    /// - Returns: `true` if the NSID is valid, or `false` if it isn't.
    public static func isValid(nsid: String) -> Bool {
        do {
            _ = try NSIDManager.parse(nsid)
            return true
        } catch {
            return false
        }
    }

}


