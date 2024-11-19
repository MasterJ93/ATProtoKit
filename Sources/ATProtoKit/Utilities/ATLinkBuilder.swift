//
//  ATLinkBuilder.swift
//
//
//  Created by Christopher Jr Riley on 2024-11-04.
//

import Foundation

/// A protocol used to easily access the metadata for a website.
///
/// To use this protocol, attach it to a `struct` of your creation, then implement
/// ``ATProtoBluesky/ExternalLinkMetadata/grabMetadata(from:)`` based on whatever method you
/// would use to access the title.
///
/// The `url` property would simply be the link captured from the `link` arguement, so you can
/// simply pass through that argument as the `url` property.
///
/// The `description` property is an optional property since some websites may not contain one.
/// It's recommended that you either add some text saying not description is provided, or by
/// some other means (e.g.: the beginning of an article in the webpage).
public protocol ATLinkBuilder: Sendable {

    /// The URL of the external link.
    var url: URL { get }

    /// Fills the properties of the `struct` conforming to `ATLinkBuilder`.
    ///
    /// This method should be able to access the link and then populate the contents of
    /// ``url``, ``title``, ``description``, and optionally, ``thumbnailURL``.
    ///
    /// - Parameter link: The URL to get the metadata.
    /// - Returns: A tuple which contains the title, description, and (optionally) the
    /// thumbnail URL of the link.
    ///
    /// - Throws: The URL doesn't exist or is invalid.
    func grabMetadata(from link: URL) async throws -> (title: String, description: String, thumbnailURL: URL?)
}
